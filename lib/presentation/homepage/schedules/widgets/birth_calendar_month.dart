import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BirthCalendarMonth extends StatefulWidget {
  const BirthCalendarMonth({super.key});

  @override
  State<BirthCalendarMonth> createState() => _BirthCalendarMonthState();
}

class _BirthCalendarMonthState extends State<BirthCalendarMonth> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.monday,
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2026, 12, 31),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
          // titleTextFormatter: ,
          titleTextFormatter: (date, locale) =>
              DateFormat.yMMMM(locale).format(date),
          titleCentered: true,
          // year
          // yearTitleTextStyle:
          //     context.textTheme.bodySmall!.copyWith(color: Color(0xffAEAEAE)),
          // monthTitleTextStyle:
          //     context.textTheme.titleMedium!.copyWith(color: Color(0xff5E5E5E)),
          formatButtonVisible: false,
          leftChevronPadding: EdgeInsets.zero,
          rightChevronPadding: EdgeInsets.zero,
          leftChevronIcon: chevronIcons(Icons.chevron_left),
          rightChevronIcon: chevronIcons(Icons.chevron_right)),
      calendarStyle: CalendarStyle(
        markerSize: 5,
        todayDecoration: BoxDecoration(
            color: const Color(0xff00AD57),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Container chevronIcons(IconData icon) {
    return Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xffCED3DE), width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon));
  }
}
