import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_colors.dart';
import '../../database/app_database.dart';
import '../../providers/daily_record_provider.dart';
import 'widgets/history_view_mode.dart';
import 'widgets/history_month_hero_card.dart';
import 'widgets/history_view_toggle.dart';
import 'widgets/history_calendar_card.dart';
import 'widgets/history_list_view.dart';
import '../../shared/widgets/app_floating_nav_bar.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  HistoryViewMode _currentMode = HistoryViewMode.calendar;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  void _onPreviousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
      _selectedDay = _focusedDay;
    });
  }

  void _onNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
      _selectedDay = _focusedDay;
    });
  }

  void _jumpToToday() {
    final now = DateTime.now();
    setState(() {
      _focusedDay = now;
      _selectedDay = now;
    });
  }

  void _openDetail(DateTime day) {
    final dateOnly = DateTime(day.year, day.month, day.day);
    context.push('/detail-rekap/${dateOnly.toIso8601String()}');
  }

  void _createRekap(DateTime day) {
    ref.read(selectedDateProvider.notifier).state = day;
    context.push('/daily-rekap');
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(allRecordsProvider);
    final canPop = Navigator.canPop(context);
    const bottomSpacing = AppFloatingNavBar.bottomSpacing;

    final now = DateTime.now();
    final isCurrentMonth = _focusedDay.year == now.year && _focusedDay.month == now.month;
    final canGoNext = !isCurrentMonth || _focusedDay.isBefore(now);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: canPop ? const AppFloatingNavBar(activeIndex: 2) : null,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        leading: canPop
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 0.5,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.maybePop(context),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),

                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Iconsax.calendar,
                    size: 20,
                    color: Color(0xFF00AA13),
                  ),
                ),
              ),
        title: const Text(
          'Riwayat Rekap',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          if (!isCurrentMonth)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: TextButton.icon(
                onPressed: _jumpToToday,
                icon: const Icon(Iconsax.calendar_tick, size: 16),
                label: const Text(
                  'Bulan Ini',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF00AA13),
                  backgroundColor: const Color(0xFFE8F8EA),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: recordsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00AA13)),
        ),
        error: (e, s) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.warning_2, size: 40, color: AppColors.error),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat riwayat',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => ref.invalidate(allRecordsProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (records) {
          // Build date lookup map
          final recordDates = <DateTime, DailyRecord>{};
          for (final r in records) {
            final dateOnly = DateTime(r.date.year, r.date.month, r.date.day);
            recordDates[dateOnly] = r;
          }

          // Filter records in focused month for hero card
          final recordsInMonth = records.where((r) {
            return r.date.year == _focusedDay.year &&
                r.date.month == _focusedDay.month;
          }).toList();

          return RefreshIndicator(
            color: const Color(0xFF00AA13),
            onRefresh: () async {
              ref.invalidate(allRecordsProvider);
            },
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // 1. Monthly Performance Hero Card
                HistoryMonthHeroCard(
                  focusedMonth: _focusedDay,
                  recordsInMonth: recordsInMonth,
                  onPreviousMonth: _onPreviousMonth,
                  onNextMonth: _onNextMonth,
                  canGoNext: canGoNext,
                ),

                const SizedBox(height: 4),

                // 2. Segmented View Toggle (Kalender / Daftar Rekap)
                HistoryViewToggle(
                  currentMode: _currentMode,
                  onModeChanged: (mode) {
                    setState(() => _currentMode = mode);
                  },
                ),

                const SizedBox(height: 6),

                // 3. Main Content based on Selected View Mode
                if (_currentMode == HistoryViewMode.calendar)
                  HistoryCalendarCard(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    calendarFormat: _calendarFormat,
                    recordDates: recordDates,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                        _selectedDay = focusedDay;
                      });
                    },
                    onOpenDetail: _openDetail,
                    onCreateRekap: _createRekap,
                  )
                else
                  HistoryListView(
                    records: records,
                    onOpenDetail: _openDetail,
                    onCreateRekap: () => _createRekap(DateTime.now()),
                  ),

                // 4. Bottom clearance for floating navbar
                SizedBox(height: bottomSpacing),
              ],
            ),
          );
        },
      ),
    );
  }
}
