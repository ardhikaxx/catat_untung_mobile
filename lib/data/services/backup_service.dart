import 'package:drift/drift.dart';
import '../../database/app_database.dart';

class BackupFormatException implements Exception {
  BackupFormatException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  static const String appName = 'Catat Untung';
  static const int formatVersion = 1;

  Future<Map<String, dynamic>> exportData() async {
    final products = await _db.select(_db.products).get();
    final records = await _db.select(_db.dailyRecords).get();
    final items = await _db.select(_db.dailyRecordItems).get();

    return {
      'version': formatVersion,
      'timestamp': DateTime.now().toIso8601String(),
      'appName': appName,
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
  }

  Future<void> restoreData(Map<String, dynamic> backup) async {
    // All validation happens BEFORE any destructive write, so an invalid
    // file can never wipe the current data.
    _validate(backup);

    await _db.transaction(() async {
      await _db.delete(_db.dailyRecordItems).go();
      await _db.delete(_db.dailyRecords).go();
      await _db.delete(_db.products).go();

      for (final raw in backup['products'] as List) {
        final p = _asMap(raw, 'produk');
        await _db.into(_db.products).insert(
              ProductsCompanion(
                id: Value(_requiredInt(p['id'], 'id produk')),
                name: Value(_requiredString(p['name'], 'nama produk')),
                hpp: Value(_optionalInt(p['hpp'], 'hpp', 0)),
                sellingPrice:
                    Value(_optionalInt(p['sellingPrice'], 'harga jual', 0)),
                unit: Value(_optionalString(p['unit'], 'satuan', 'pcs')),
                isActive: Value(p['isActive'] is bool ? p['isActive'] as bool : true),
                createdAt: Value(_optionalDate(p['createdAt'])),
                updatedAt: Value(_optionalDate(p['updatedAt'])),
              ),
            );
      }

      for (final raw in backup['dailyRecords'] as List) {
        final r = _asMap(raw, 'rekap');
        await _db.into(_db.dailyRecords).insert(
              DailyRecordsCompanion(
                id: Value(_requiredInt(r['id'], 'id rekap')),
                date: Value(_requiredDate(r['date'], 'tanggal rekap')),
                totalRevenue:
                    Value(_optionalInt(r['totalRevenue'], 'omzet', 0)),
                totalCost: Value(_optionalInt(r['totalCost'], 'modal', 0)),
                totalProfit: Value(_optionalInt(r['totalProfit'], 'laba', 0)),
                totalQuantity:
                    Value(_optionalInt(r['totalQuantity'], 'jumlah terjual', 0)),
                createdAt: Value(_optionalDate(r['createdAt'])),
                updatedAt: Value(_optionalDate(r['updatedAt'])),
              ),
            );
      }

      for (final raw in backup['dailyRecordItems'] as List) {
        final i = _asMap(raw, 'item rekap');
        final id = i['id'];
        await _db.into(_db.dailyRecordItems).insert(
              DailyRecordItemsCompanion(
                id: id is int ? Value(id) : const Value.absent(),
                dailyRecordId:
                    Value(_requiredInt(i['dailyRecordId'], 'id rekap item')),
                productId: i['productId'] is int
                    ? Value(i['productId'] as int)
                    : const Value(null),
                productNameSnapshot:
                    Value(_requiredString(i['productNameSnapshot'], 'nama produk item')),
                unitSnapshot:
                    Value(_optionalString(i['unitSnapshot'], 'satuan item', 'pcs')),
                hppSnapshot: Value(_optionalInt(i['hppSnapshot'], 'hpp item', 0)),
                sellingPriceSnapshot:
                    Value(_optionalInt(i['sellingPriceSnapshot'], 'harga item', 0)),
                quantity: Value(_optionalInt(i['quantity'], 'jumlah item', 0)),
                subtotalRevenue:
                    Value(_optionalInt(i['subtotalRevenue'], 'subtotal omzet', 0)),
                subtotalCost:
                    Value(_optionalInt(i['subtotalCost'], 'subtotal modal', 0)),
                subtotalProfit:
                    Value(_optionalInt(i['subtotalProfit'], 'subtotal laba', 0)),
                createdAt: Value(_optionalDate(i['createdAt'])),
              ),
            );
      }
    });
  }

  void _validate(Map<String, dynamic> backup) {
    if (backup['appName'] != appName) {
      throw BackupFormatException('File backup tidak valid');
    }

    final version = backup['version'];
    if (version is! int || version < 1 || version > formatVersion) {
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
