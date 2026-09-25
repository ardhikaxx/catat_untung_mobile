import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../database/app_database.dart';
import '../../../l10n/generated/app_localizations.dart';
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

    // Returns a sliver so the host can keep the record list lazy.
    return SliverMainAxisGroup(
      slivers: [
        // Filter Chips Row
        SliverToBoxAdapter(
          child: Padding(
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
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 4)),

        // Lazy list of records
        if (filteredRecords.isEmpty)
          SliverToBoxAdapter(child: _buildEmptyState(context))
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final record = filteredRecords[index];
                return HistoryRecordCard(
                  record: record,
                  onTap: () => widget.onOpenDetail(record.date),
                );
              },
              childCount: filteredRecords.length,
            ),
          ),
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

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.greenTint,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.calendarX,
                  size: 38,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.histNoRecap ?? 'Tidak Ada Rekap',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _selectedFilter == RecordFilter.all
                  ? l10n?.histEmptyNoSales ??
                      'Belum ada catatan penjualan yang tersimpan.'
                  : l10n?.histEmptyFiltered ??
                      'Tidak ada catatan rekap pada filter yang dipilih.',
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
                icon: const Icon(LucideIcons.plus, size: 16),
                label: Text(l10n?.histCreateRecapNow ?? 'Buat Rekap Sekarang'),
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
