import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/database_provider.dart';
import '../../shared/widgets/app_back_button.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';
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
    final l10n = AppLocalizations.of(context);
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

      csvData.add([]);
      csvData.add(['${AppConstants.appName} - ${AppConstants.copyright}']);

      final csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = p.join(
        directory.path,
        'laporan_${DateFormat('yyyyMMdd').format(_startDate)}_${DateFormat('yyyyMMdd').format(_endDate)}.csv',
      );
      final file = File(filePath);
      await file.writeAsString(csv);

      await Share.shareXFiles([XFile(filePath)], text: l10n?.expShareText ?? 'Laporan Catat Untung');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n?.expCsvExportSuccess ?? 'CSV berhasil diekspor')),
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
    final l10n = AppLocalizations.of(context);
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

      final logoBytes = await rootBundle.load('assets/logo.png');
      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());


      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          footer: (context) => pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(top: 16),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Catat Untung - ${AppConstants.copyright}',
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                ),
                pw.Text(
                  'Halaman ${context.pageNumber} dari ${context.pagesCount}',
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
          build: (context) => [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  width: 44,
                  height: 44,
                  margin: const pw.EdgeInsets.only(right: 12),
                  child: pw.ClipRRect(
                    horizontalRadius: 10,
                    verticalRadius: 10,
                    child: pw.Image(logoImage),
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Catat Untung',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Laporan Rekap Penjualan Toko',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Divider(thickness: 1.5, color: PdfColors.grey300),
            pw.SizedBox(height: 8),
            pw.Text(
              'Periode: ${DateFormatter.formatShort(_startDate)} - ${DateFormatter.formatShort(_endDate)}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
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

      await Share.shareXFiles([XFile(filePath)], text: l10n?.expShareText ?? 'Laporan Catat Untung');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n?.expPdfExportSuccess ?? 'PDF berhasil diekspor')),
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: const AppFloatingNavBar(activeIndex: 3),
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(l10n?.expTitle ?? 'Export Laporan'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n?.expSelectPeriod ?? 'Pilih Periode',
            style: const TextStyle(
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
                  icon: const Icon(LucideIcons.calendar, size: 16),
                  label: Text(DateFormatter.formatShort(_startDate)),
                ),
              ),
              const SizedBox(width: 8),
              const Text('—', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(isStart: false),
                  icon: const Icon(LucideIcons.calendar, size: 16),
                  label: Text(DateFormatter.formatShort(_endDate)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (_isExporting)
            LoadingState(message: l10n?.expExporting ?? 'Mengekspor data...')
          else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _exportPdf,
                icon: const Icon(LucideIcons.file),
                label: Text(l10n?.expExportPdfButton ?? 'Ekspor PDF'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _exportCsv,
                icon: const Icon(LucideIcons.barChart2),
                label: Text(l10n?.expExportCsvButton ?? 'Ekspor CSV'),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                AppConstants.copyright,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary.withAlpha(180),
                ),
              ),
            ),
            const SizedBox(height: AppFloatingNavBar.bottomSpacing),
          ],
        ],
      ),
    );
  }
}
