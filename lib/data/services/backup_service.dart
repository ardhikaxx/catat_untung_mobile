import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class BackupFormatException implements Exception {
  BackupFormatException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// How a backup file is applied to the current database.
enum RestoreMode {
  /// Delete everything, then insert the file contents (default).
  replace,

  /// Keep existing rows and only add what is missing, matched by product name
  /// and by rekap date. Existing days are never overwritten or double counted.
  merge,
}

/// Summary of what a restore actually changed.
class RestoreResult {
  const RestoreResult({
    required this.products,
    required this.records,
    required this.items,
    required this.skippedRecords,
    required this.mode,
  });

  final int products;
  final int records;
  final int items;
  final int skippedRecords;
  final RestoreMode mode;
}

class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  static const String appName = 'Catat Untung';
  static const int formatVersion = 2;

  /// Oldest file version this build can still read.
  static const int minSupportedVersion = 1;

  static const List<String> _payloadKeys = [
    'products',
    'dailyRecords',
    'dailyRecordItems',
  ];

  Future<Map<String, dynamic>> exportData() async {
    final products = await _db.select(_db.products).get();
    final records = await _db.select(_db.dailyRecords).get();
    final items = await _db.select(_db.dailyRecordItems).get();

    final payload = <String, dynamic>{
      'products': products
          .map((p) => {
                'id': p.id,
                'name': p.name,
                'hpp': p.hpp,
                'sellingPrice': p.sellingPrice,
                'unit': p.unit,
                'isActive': p.isActive,
                'createdAt': p.createdAt.toIso8601String(),
                'updatedAt': p.updatedAt.toIso8601String(),
              })
          .toList(),
      'dailyRecords': records
          .map((r) => {
                'id': r.id,
                'date': r.date.toIso8601String(),
                'totalRevenue': r.totalRevenue,
                'totalCost': r.totalCost,
                'totalProfit': r.totalProfit,
                'totalQuantity': r.totalQuantity,
                'createdAt': r.createdAt.toIso8601String(),
                'updatedAt': r.updatedAt.toIso8601String(),
              })
          .toList(),
      'dailyRecordItems': items
          .map((i) => {
                'id': i.id,
                'dailyRecordId': i.dailyRecordId,
                'productId': i.productId,
                'productNameSnapshot': i.productNameSnapshot,
                'unitSnapshot': i.unitSnapshot,
                'hppSnapshot': i.hppSnapshot,
                'sellingPriceSnapshot': i.sellingPriceSnapshot,
                'quantity': i.quantity,
                'subtotalRevenue': i.subtotalRevenue,
                'subtotalCost': i.subtotalCost,
                'subtotalProfit': i.subtotalProfit,
                'createdAt': i.createdAt.toIso8601String(),
              })
          .toList(),
    };

    return {
      'version': formatVersion,
      'timestamp': DateTime.now().toIso8601String(),
      'appName': appName,
      'checksum': checksumOf(payload),
      ...payload,
    };
  }

  /// SHA-256 of the canonical payload encoding, used to detect truncated or
  /// hand-edited backup files before they are allowed to touch the database.
  static String checksumOf(Map<String, dynamic> payload) {
    final canonical = <String, dynamic>{
      for (final key in _payloadKeys) key: payload[key],
    };
    return sha256.convert(utf8.encode(jsonEncode(canonical))).toString();
  }

  Future<RestoreResult> restoreData(
    Map<String, dynamic> backup, {
    RestoreMode mode = RestoreMode.replace,
  }) async {
    // All validation happens BEFORE any destructive write, so an invalid
    // file can never wipe the current data.
    _validate(backup);

    if (mode == RestoreMode.replace) {
      await _db.transaction(() async {
        await _db.delete(_db.dailyRecordItems).go();
        await _db.delete(_db.dailyRecords).go();
        await _db.delete(_db.products).go();
        for (final raw in backup['products'] as List) {
          final p = _asMap(raw, 'produk');
          await _insertProduct(p, id: _requiredInt(p['id'], 'id produk'));
        }
        for (final raw in backup['dailyRecords'] as List) {
          final r = _asMap(raw, 'rekap');
          await _insertRecord(r, id: _requiredInt(r['id'], 'id rekap'));
        }
        for (final raw in backup['dailyRecordItems'] as List) {
          await _insertItem(_asMap(raw, 'item rekap'));
        }
      });

      return RestoreResult(
        products: (backup['products'] as List).length,
        records: (backup['dailyRecords'] as List).length,
        items: (backup['dailyRecordItems'] as List).length,
        skippedRecords: 0,
        mode: mode,
      );
    }

    return _merge(backup);
  }

  Future<RestoreResult> _merge(Map<String, dynamic> backup) async {
    var productsAdded = 0;
    var recordsAdded = 0;
    var itemsAdded = 0;
    var recordsSkipped = 0;

    final productIdMap = <int, int>{};
    final recordIdMap = <int, int>{};
    final skippedRecordIds = <int>{};

    await _db.transaction(() async {
      for (final raw in backup['products'] as List) {
        final p = _asMap(raw, 'produk');
        final id = _requiredInt(p['id'], 'id produk');
        final name = _requiredString(p['name'], 'nama produk');
        final existing =
            await (_db.select(_db.products)..where((t) => t.name.equals(name)))
                .getSingleOrNull();
        if (existing != null) {
          productIdMap[id] = existing.id;
          continue;
        }
        productIdMap[id] = await _insertProduct(p);
        productsAdded++;
      }

      for (final raw in backup['dailyRecords'] as List) {
        final r = _asMap(raw, 'rekap');
        final id = _requiredInt(r['id'], 'id rekap');
        final date = _requiredDate(r['date'], 'tanggal rekap');
        final day = DateTime(date.year, date.month, date.day);
        final existing = await (_db.select(_db.dailyRecords)
              ..where((t) => t.date.equals(day)))
            .getSingleOrNull();
        if (existing != null) {
          // That day is already recorded locally: keep the local numbers and
          // ignore the items that belong to it.
          skippedRecordIds.add(id);
          recordsSkipped++;
          continue;
        }
        recordIdMap[id] = await _insertRecord(r);
        recordsAdded++;
      }

      for (final raw in backup['dailyRecordItems'] as List) {
        final i = _asMap(raw, 'item rekap');
        final sourceRecordId = _requiredInt(i['dailyRecordId'], 'id rekap item');
        if (skippedRecordIds.contains(sourceRecordId)) continue;
        final targetRecordId = recordIdMap[sourceRecordId];
        if (targetRecordId == null) continue;
        await _insertItem(i, dailyRecordId: targetRecordId, productIdMap: productIdMap);
        itemsAdded++;
      }
    });

    return RestoreResult(
      products: productsAdded,
      records: recordsAdded,
      items: itemsAdded,
      skippedRecords: recordsSkipped,
      mode: RestoreMode.merge,
    );
  }

  Future<int> _insertProduct(Map<String, dynamic> p, {int? id}) async {
    return _db.into(_db.products).insert(
          ProductsCompanion(
            id: id == null ? const Value.absent() : Value(id),
            name: Value(_requiredString(p['name'], 'nama produk')),
            hpp: Value(_optionalInt(p['hpp'], 'hpp', 0)),
            sellingPrice: Value(_optionalInt(p['sellingPrice'], 'harga jual', 0)),
            unit: Value(_optionalString(p['unit'], 'satuan', 'pcs')),
            isActive: Value(p['isActive'] is bool ? p['isActive'] as bool : true),
            createdAt: Value(_optionalDate(p['createdAt'])),
            updatedAt: Value(_optionalDate(p['updatedAt'])),
          ),
        );
  }

  Future<int> _insertRecord(Map<String, dynamic> r, {int? id}) async {
    return _db.into(_db.dailyRecords).insert(
          DailyRecordsCompanion(
            id: id == null ? const Value.absent() : Value(id),
            date: Value(_requiredDate(r['date'], 'tanggal rekap')),
            totalRevenue: Value(_optionalInt(r['totalRevenue'], 'omzet', 0)),
            totalCost: Value(_optionalInt(r['totalCost'], 'modal', 0)),
            totalProfit: Value(_optionalInt(r['totalProfit'], 'laba', 0)),
            totalQuantity: Value(_optionalInt(r['totalQuantity'], 'jumlah terjual', 0)),
            createdAt: Value(_optionalDate(r['createdAt'])),
            updatedAt: Value(_optionalDate(r['updatedAt'])),
          ),
        );
  }

  Future<int> _insertItem(
    Map<String, dynamic> i, {
    int? dailyRecordId,
    Map<int, int>? productIdMap,
  }) async {
    final sourceProductId = i['productId'];
    int? productId;
    if (sourceProductId is int) {
      productId = productIdMap?[sourceProductId] ?? sourceProductId;
    }
    final recordId =
        dailyRecordId ?? _requiredInt(i['dailyRecordId'], 'id rekap item');

    return _db.into(_db.dailyRecordItems).insert(
          DailyRecordItemsCompanion(
            dailyRecordId: Value(recordId),
            productId: Value(productId),
            productNameSnapshot:
                Value(_requiredString(i['productNameSnapshot'], 'nama produk item')),
            unitSnapshot: Value(_optionalString(i['unitSnapshot'], 'satuan item', 'pcs')),
            hppSnapshot: Value(_optionalInt(i['hppSnapshot'], 'hpp item', 0)),
            sellingPriceSnapshot:
                Value(_optionalInt(i['sellingPriceSnapshot'], 'harga item', 0)),
            quantity: Value(_optionalInt(i['quantity'], 'jumlah item', 0)),
            subtotalRevenue: Value(_optionalInt(i['subtotalRevenue'], 'subtotal omzet', 0)),
            subtotalCost: Value(_optionalInt(i['subtotalCost'], 'subtotal modal', 0)),
            subtotalProfit: Value(_optionalInt(i['subtotalProfit'], 'subtotal laba', 0)),
            createdAt: Value(_optionalDate(i['createdAt'])),
          ),
        );
  }

  void _validate(Map<String, dynamic> backup) {
    if (backup['appName'] != appName) {
      throw BackupFormatException('File backup tidak valid');
    }

    final version = backup['version'];
    if (version is! int || version < minSupportedVersion || version > formatVersion) {
      throw BackupFormatException(
        'Versi backup ($version) tidak didukung. Perbarui aplikasi untuk memulihkan file ini.',
      );
    }

    final products = backup['products'];
    final records = backup['dailyRecords'];
    final items = backup['dailyRecordItems'];
    if (products is! List || records is! List || items is! List) {
      throw BackupFormatException('Struktur file backup rusak');
    }

    // Files written by v1 have no checksum; everything newer must match, which
    // catches truncated downloads and manual edits.
    final checksum = backup['checksum'];
    if (version >= 2) {
      if (checksum is! String || checksum.isEmpty) {
        throw BackupFormatException(
          'File backup tidak memiliki checksum. File mungkin rusak atau dibuat oleh aplikasi lain.',
        );
      }
      if (checksum != checksumOf(backup)) {
        throw BackupFormatException(
          'Checksum tidak cocok: file backup rusak atau isinya diubah. Buat backup baru lalu coba lagi.',
        );
      }
    }

    final productIds = <int>{};
    for (final raw in products) {
      final p = _asMap(raw, 'produk');
      final id = _requiredInt(p['id'], 'id produk');
      _requiredString(p['name'], 'nama produk');
      if (!productIds.add(id)) {
        throw BackupFormatException('Struktur file backup rusak: id produk duplikat ($id)');
      }
    }

    final recordIds = <int>{};
    final recordDates = <DateTime>{};
    for (final raw in records) {
      final r = _asMap(raw, 'rekap');
      final id = _requiredInt(r['id'], 'id rekap');
      final date = _requiredDate(r['date'], 'tanggal rekap');
      if (!recordIds.add(id)) {
        throw BackupFormatException('Struktur file backup rusak: id rekap duplikat ($id)');
      }
      if (!recordDates.add(DateTime(date.year, date.month, date.day))) {
        throw BackupFormatException(
          'Struktur file backup rusak: tanggal rekap duplikat',
        );
      }
    }

    for (final raw in items) {
      final i = _asMap(raw, 'item rekap');
      final recordId = _requiredInt(i['dailyRecordId'], 'id rekap item');
      if (!recordIds.contains(recordId)) {
        throw BackupFormatException(
          'Struktur file backup rusak: item menunjuk rekap tidak ada ($recordId)',
        );
      }
      final productId = i['productId'];
      if (productId != null && (productId is! int || !productIds.contains(productId))) {
        throw BackupFormatException(
          'Struktur file backup rusak: item menunjuk produk tidak ada ($productId)',
        );
      }
      _requiredString(i['productNameSnapshot'], 'nama produk item');
    }
  }

  Map<String, dynamic> _asMap(Object? value, String label) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw BackupFormatException('Struktur file backup rusak: $label tidak valid');
  }

  int _requiredInt(Object? value, String field) {
    if (value is int) return value;
    throw BackupFormatException('Field "$field" tidak valid');
  }

  int _optionalInt(Object? value, String field, int fallback) {
    if (value is int) return value;
    if (value == null) return fallback;
    throw BackupFormatException('Field "$field" tidak valid');
  }

  String _requiredString(Object? value, String field) {
    if (value is String && value.isNotEmpty) return value;
    throw BackupFormatException('Field "$field" tidak valid');
  }

  String _optionalString(Object? value, String field, String fallback) {
    if (value is String) return value;
    if (value == null) return fallback;
    throw BackupFormatException('Field "$field" tidak valid');
  }

  DateTime _requiredDate(Object? value, String field) {
    final parsed = value is String ? DateTime.tryParse(value) : null;
    if (parsed == null) throw BackupFormatException('Field "$field" tidak valid');
    return parsed;
  }

  DateTime _optionalDate(Object? value) {
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
