import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../database/app_database.dart';
import 'history_record_card.dart';

enum RecordFilter {
  all,
  profit,
  loss,
}

class HistoryListView extends StatefulWidget {
  final List<DailyRecord> records;
  final ValueChanged<DateTime> onOpenDetail;
  final VoidCallback? onCreateRekap;

  const HistoryListView({
    super.key,
    required this.records,
    required this.onOpenDetail,
    this.onCreateRekap,
  });

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  RecordFilter _selectedFilter = RecordFilter.all;

  @override
  Widget build(BuildContext context) {
    final profitCount = widget.records.where((r) => r.totalProfit >= 0).length;
    final lossCount = widget.records.where((r) => r.totalProfit < 0).length;

    final filteredRecords = widget.records.where((r) {
      if (_selectedFilter == RecordFilter.profit) return r.totalProfit >= 0;
      if (_selectedFilter == RecordFilter.loss) return r.totalProfit < 0;
      return true;
    }).toList();

    // Sort descending by date (latest first)
    filteredRecords.sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Chips Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Row(
            children: [
              _buildFilterChip(
                label: 'Semua (${widget.records.length})',
                filter: RecordFilter.all,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Untung ($profitCount)',
                filter: RecordFilter.profit,
                color: AppColors.profit,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Rugi ($lossCount)',
                filter: RecordFilter.loss,
                color: AppColors.loss,
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // List of Records
        if (filteredRecords.isEmpty)
          _buildEmptyState()
        else
          ...List.generate(filteredRecords.length, (index) {
            final record = filteredRecords[index];
            return HistoryRecordCard(
              record: record,
              onTap: () => widget.onOpenDetail(record.date),
            );
          }),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required RecordFilter filter,
    required Color color,
  }) {
    final isSelected = _selectedFilter == filter;

    return InkWell(
      onTap: () => setState(() => _selectedFilter = filter),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.greyBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.greenTint,
                borderRadius: BorderRadius.circular(22),
              ),
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  AppGifs.calendar,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Rekap',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _selectedFilter == RecordFilter.all
                  ? 'Belum ada catatan penjualan yang tersimpan.'
                  : 'Tidak ada catatan rekap pada filter yang dipilih.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (widget.onCreateRekap != null &&
                _selectedFilter == RecordFilter.all) ...[
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: widget.onCreateRekap,
                icon: const Icon(Iconsax.add, size: 16),
                label: const Text('Buat Rekap Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
