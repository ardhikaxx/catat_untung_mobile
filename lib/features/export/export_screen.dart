import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/database_provider.dart';
import '../../shared/widgets/loading_state.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isExporting = false;

  Future<void> _selectDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);
    try {
      final repo = ref.read(dailyRecordRepositoryProvider);
      final items = await repo.getItemsBetween(_startDate, _endDate);
      final records = await repo.getRecordsBetween(_startDate, _endDate);

      final csvData = <List<String>>[
        [
          'Tanggal',
          'Nama Produk',
          'Qty',
          'HPP/Unit',
          'Jual/Unit',
          'Subtotal Omzet',
          'Subtotal Modal',
          'Laba',
        ],
      ];

      for (final item in items) {
        final record = records.firstWhere(
          (r) => r.id == item.dailyRecordId,
          orElse: () => records.first,
        );
        final profit = item.subtotalRevenue - item.subtotalCost;
        csvData.add([
          DateFormat('yyyy-MM-dd').format(record.date),
          item.productNameSnapshot,
          '${item.quantity}',
          '${item.hppSnapshot}',
          '${item.sellingPriceSnapshot}',
          '${item.subtotalRevenue}',
          '${item.subtotalCost}',
          '$profit',
        ]);
      }

      final csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = p.join(
        directory.path,
        'laporan_${DateFormat('yyyyMMdd').format(_startDate)}_${DateFormat('yyyyMMdd').format(_endDate)}.csv',
      );
      final file = File(filePath);
      await file.writeAsString(csv);

      await Share.shareXFiles([XFile(filePath)], text: 'Laporan Catat Untung');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV berhasil diekspor')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal ekspor CSV: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      final repo = ref.read(dailyRecordRepositoryProvider);
      final records = await repo.getRecordsBetween(_startDate, _endDate);
      final items = await repo.getItemsBetween(_startDate, _endDate);

      final totalRevenue = records.fold<int>(0, (sum, r) => sum + r.totalRevenue);
      final totalCost = records.fold<int>(0, (sum, r) => sum + r.totalCost);
      final totalProfit = totalRevenue - totalCost;
      final margin = totalRevenue > 0
          ? ((totalProfit / totalRevenue) * 100).round()
          : 0;

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Catat Untung',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Header(
              level: 1,
              child: pw.Text('Laporan Penjualan'),
            ),
            pw.Text(
              'Periode: ${DateFormatter.formatShort(_startDate)} - ${DateFormatter.formatShort(_endDate)}',
            ),
            pw.SizedBox(height: 20),
            pw.Text('Total Omzet: ${CurrencyFormatter.formatRupiah(totalRevenue)}'),
            pw.Text('Total Modal: ${CurrencyFormatter.formatRupiah(totalCost)}'),
            pw.Text('Laba Bersih: ${CurrencyFormatter.formatRupiah(totalProfit)}'),
            pw.Text('Margin: ${CurrencyFormatter.formatPercent(margin / 100)}'),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Tanggal', 'Produk', 'Qty', 'Omzet', 'Modal', 'Laba'],
              data: items.map((item) {
                final profit = item.subtotalRevenue - item.subtotalCost;
                return [
                  DateFormat('dd/MM').format(item.createdAt),
                  item.productNameSnapshot,
                  '${item.quantity}',
                  CurrencyFormatter.formatRupiah(item.subtotalRevenue),
                  CurrencyFormatter.formatRupiah(item.subtotalCost),
                  CurrencyFormatter.formatRupiah(profit),
                ];
              }).toList(),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerStyle: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final filePath = p.join(
        directory.path,
        'laporan_${DateFormat('yyyyMMdd').format(_startDate)}_${DateFormat('yyyyMMdd').format(_endDate)}.pdf',
      );
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(filePath)], text: 'Laporan Catat Untung');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF berhasil diekspor')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal ekspor PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Laporan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pilih Periode',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(isStart: true),
                  icon: const Icon(Iconsax.calendar, size: 16),
                  label: Text(DateFormatter.formatShort(_startDate)),
                ),
              ),
              const SizedBox(width: 8),
              const Text('—', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(isStart: false),
                  icon: const Icon(Iconsax.calendar, size: 16),
                  label: Text(DateFormatter.formatShort(_endDate)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (_isExporting)
            const LoadingState(message: 'Mengekspor data...')
          else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _exportPdf,
                icon: const Icon(Iconsax.document),
                label: const Text('Ekspor PDF'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _exportCsv,
                icon: const Icon(Iconsax.chart_2),
                label: const Text('Ekspor CSV'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
