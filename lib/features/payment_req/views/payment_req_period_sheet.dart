import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/core/widgets/app_chip.dart';
import 'package:ncapp/core/widgets/bottom_sheet_container.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/theme/app_theme.dart';

class PaymentReqPeriodSheet extends StatefulWidget {
  const PaymentReqPeriodSheet({super.key});

  @override
  State<PaymentReqPeriodSheet> createState() => _PaymentReqPeriodSheetState();
}

class _PaymentReqPeriodSheetState extends State<PaymentReqPeriodSheet> {
  late final PaymentReqController controller = Get.find();

  late PeriodFilterType _type;
  late int _month;
  late int _quarter;
  DateTime? _start;
  DateTime? _end;

  bool _showCalendar = false;
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    _type = controller.periodType.value;
    _month = controller.selectedMonth.value;
    _quarter = controller.selectedQuarter.value;
    _start = controller.rangeStart.value;
    _end = controller.rangeEnd.value;
    final now = DateTime.now();
    _displayMonth = DateTime(_start?.year ?? now.year, _start?.month ?? now.month);
  }

  void _apply() {
    controller.applyPeriod(
      type: _type,
      month: _month,
      quarter: _quarter,
      start: _type == PeriodFilterType.range ? _start : null,
      end: _type == PeriodFilterType.range ? _end : null,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      maxHeightFactor: 0.9,
      children: [
          Flexible(
            child: SingleChildScrollView(
              child: _showCalendar ? _buildCalendarPage() : _buildMainPage(),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.of(context).padding.bottom + 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text(
                  'Шүүж харах',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
    );
  }

  // ── Main filter page ───────────────────────────────────────
  Widget _buildMainPage() {
    final now = DateTime.now();
    final currentQuarter = (now.month - 1) ~/ 3 + 1;
    final hasRange = _start != null && _end != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              const Text(
                'Хугацаа сонгох',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${now.year} он',
                style:
                    const TextStyle(fontSize: 13, color: AppTheme.textGrey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Сараар шүүх',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [
              for (int m = now.month; m >= 1; m--)
                AppChip(
                  label: '$m-р сар',
                  selected: _type == PeriodFilterType.month && _month == m,
                  onTap: () => setState(() {
                    _type = PeriodFilterType.month;
                    _month = m;
                    _start = null;
                    _end = null;
                  }),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Улирлаар шүүх',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [
              for (int q = currentQuarter; q >= 1; q--)
                AppChip(
                  label: '$q-р улирал',
                  selected: _type == PeriodFilterType.quarter && _quarter == q,
                  onTap: () => setState(() {
                    _type = PeriodFilterType.quarter;
                    _quarter = q;
                    _start = null;
                    _end = null;
                  }),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Хоногоор шүүх',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _showCalendar = true),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.calendar_month,
                    size: 20, color: Color(0xFFFF3B30)),
                const SizedBox(width: 8),
                const Text(
                  'Огноо',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                ),
                const Spacer(),
                Text(
                  hasRange
                      ? '${PaymentReqController.formatRangeDate(_start!)} - '
                          '${PaymentReqController.formatRangeDate(_end!)}'
                      : 'Сонгох',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: hasRange ? FontWeight.w600 : FontWeight.w400,
                    color: hasRange ? AppTheme.textGrey : AppTheme.textGrey,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right,
                    size: 18, color: AppTheme.textGrey),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Calendar page ──────────────────────────────────────────
  Widget _buildCalendarPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  size: 16, color: AppTheme.textDark),
              onPressed: () => setState(() => _showCalendar = false),
            ),
            const Text(
              'Хоногоор шүүх',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _displayMonth = DateTime(
                    _displayMonth.year, _displayMonth.month - 1)),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.chevron_left,
                      size: 22, color: AppTheme.textDark),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${_displayMonth.month}-р сар ${_displayMonth.year}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _displayMonth = DateTime(
                    _displayMonth.year, _displayMonth.month + 1)),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.chevron_right,
                      size: 22, color: AppTheme.textDark),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (final d in const ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'])
                Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildDayGrid(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDayGrid() {
    final year = _displayMonth.year;
    final month = _displayMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leading = DateTime(year, month, 1).weekday - 1; // Monday first
    final totalCells =
        ((leading + daysInMonth) % 7 == 0) ? leading + daysInMonth : (leading + daysInMonth) + (7 - (leading + daysInMonth) % 7);

    final cells = List<DateTime>.generate(
      totalCells,
      (i) => DateTime(year, month, i - leading + 1),
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.1,
      ),
      itemCount: cells.length,
      itemBuilder: (_, i) => _DayCell(
        day: cells[i],
        inMonth: cells[i].month == month,
        start: _start,
        end: _end,
        onTap: _onDayTap,
      ),
    );
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_start == null || _end != null) {
        _start = day;
        _end = null;
      } else if (day.isBefore(_start!)) {
        _start = day;
      } else {
        _end = day;
        _type = PeriodFilterType.range;
      }
    });
  }
}

// ── Day cell ───────────────────────────────────────────────
class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool inMonth;
  final DateTime? start;
  final DateTime? end;
  final ValueChanged<DateTime> onTap;

  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.start,
    required this.end,
    required this.onTap,
  });

  bool _sameDay(DateTime? a, DateTime b) =>
      a != null && a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final isStart = _sameDay(start, day);
    final isEnd = _sameDay(end, day);
    final hasRange = start != null && end != null;
    final inRange = hasRange &&
        day.isAfter(start!) &&
        day.isBefore(end!) &&
        !isStart &&
        !isEnd;
    final bandColor = AppTheme.primary.withValues(alpha: 0.12);
    const bandInset = 16.0; // bigger = thinner range band

    return GestureDetector(
      onTap: inMonth ? () => onTap(day) : null,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          if (inRange)
            Positioned.fill(
              top: bandInset,
              bottom: bandInset,
              child: Container(color: bandColor),
            ),
          if (isStart && hasRange && !isEnd)
            Positioned.fill(
              top: bandInset,
              bottom: bandInset,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(child: Container(color: bandColor)),
                ],
              ),
            ),
          if (isEnd && hasRange && !isStart)
            Positioned.fill(
              top: bandInset,
              bottom: bandInset,
              child: Row(
                children: [
                  Expanded(child: Container(color: bandColor)),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          Center(
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: (isStart || isEnd)
                  ? const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      (isStart || isEnd) ? FontWeight.w600 : FontWeight.w400,
                  color: (isStart || isEnd)
                      ? Colors.white
                      : inMonth
                          ? AppTheme.textDark
                          : const Color(0xFFB0B8C1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
