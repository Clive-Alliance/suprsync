// // Copyright 2019 Aleksander Woźniak
// // SPDX-License-Identifier: Apache-2.0

// // ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suprsync/presentation/homepage/calendar/calendar_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class TableEventsExample extends StatelessWidget {
  TableEventsExample({super.key});

  final CalendarController calendarController = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => TableCalendar<String>(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2026, 12, 31),
          focusedDay: calendarController.focusedDay.value,
          selectedDayPredicate: (day) =>
              isSameDay(calendarController.focusedDay.value, day),
          rangeStartDay: calendarController.rangeStart.value,
          rangeEndDay: calendarController.rangeEnd.value,
          calendarFormat: calendarController.calendarFormat.value,
          rangeSelectionMode: calendarController.rangeSelectionMode.value,
          eventLoader: (day) =>
              calendarController.kEvents[day] ?? [], // Get events for the day
          headerStyle: HeaderStyle(
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMMM(locale).format(date),
              titleCentered: true,
              formatButtonVisible: false,
              leftChevronPadding: EdgeInsets.zero,
              rightChevronPadding: EdgeInsets.zero,
              leftChevronIcon: Icon(Icons.chevron_left),
              rightChevronIcon: Icon(Icons.chevron_right)),
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: Color(0xffffffff),
            ),
            markerSize: 5,
            selectedTextStyle: const TextStyle(color: Color(0xff000000)),
            markerDecoration: const BoxDecoration(
                color: Color(0xffD9694D), shape: BoxShape.circle),
            todayTextStyle: const TextStyle(color: Color(0xff000000)),
            todayDecoration: BoxDecoration(
                color: const Color(0xffffffff),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10)),
          ),
          onDaySelected: calendarController.onDaySelected,
          onRangeSelected: calendarController.onRangeSelected,
          onFormatChanged: (format) {
            if (calendarController.calendarFormat.value != format) {
              calendarController.calendarFormat.value = format;
            }
          },
          onPageChanged: (focusedDay) {
            calendarController.focusedDay.value = focusedDay;
          },
        ));
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
