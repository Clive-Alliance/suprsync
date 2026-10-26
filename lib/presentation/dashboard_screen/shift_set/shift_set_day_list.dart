import 'package:flutter/material.dart';
import 'package:suprsync/models/shift_set.dart';

const _months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

class ShiftSetDayList extends StatelessWidget {
  const ShiftSetDayList({
    super.key,
    required this.days,
    required this.selectedOffsets,
    required this.repeat,
    required this.onToggle,
  });

  final List<ShiftSetDay> days;
  final Set<int> selectedOffsets;
  final ShiftSetRepeat repeat;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final weeks = <int, List<ShiftSetDay>>{};
    for (final day in days) {
      weeks.putIfAbsent(day.weekIndex, () => []).add(day);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 12),
      children: [
        for (final entry in weeks.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              '${weekNameFor(entry.key)} week',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff056033),
              ),
            ),
          ),
          for (final day in entry.value)
            _DayTile(
              day: day,
              repeat: repeat,
              selected: selectedOffsets.contains(day.offset),
              onTap: () => onToggle(day.offset),
            ),
        ],
      ],
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    required this.day,
    required this.repeat,
    required this.selected,
    required this.onTap,
  });

  final ShiftSetDay day;
  final ShiftSetRepeat repeat;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date =
        '${day.date.day} ${_months[day.date.month - 1]} ${day.date.year}';
    final subtitle = repeat == ShiftSetRepeat.dayOfMonth
        ? '$date · repeats on the ${day.dayOfMonth}${_ordinal(day.dayOfMonth)}'
        : date;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? const Color(0xffEBFFF5) : const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey('shift-day-${day.offset}'),
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? const Color(0xff00AD57)
                    : const Color(0xffE6E6E6),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.patternLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6D6A6A),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected
                      ? const Color(0xff00AD57)
                      : const Color(0xffC8C8C8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _ordinal(int day) {
  if (day >= 11 && day <= 13) return 'th';
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
