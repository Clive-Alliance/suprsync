import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'dart:math';

import 'package:suprsync/presentation/homepage/schedules/widgets/days_grid.dart';

class DayGrid extends StatefulWidget {
  final DateTime? lastPeriodDate;
  DayGrid({required this.lastPeriodDate});

  @override
  State<DayGrid> createState() => _DayGridState();
}

class _DayGridState extends State<DayGrid> {
  final int periodDuration = 4;

  final int follicularDuration = 6;

  final int ovulationDuration = 5;

  final int cycleDuration = 24;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final DateTime firstDayOfCalendar = DateTime(
        widget.lastPeriodDate?.year ?? DateTime.now().year,
        12,
        1); // Default to December if no period date
    final DateTime lastDayOfCalendar =
        firstDayOfCalendar.add(Duration(days: 90)); // 3 months range
    final List<DateTime> calendarDates =
        _generateCalendar(firstDayOfCalendar, lastDayOfCalendar);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Days of the week header (Mon, Tue, etc.)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final weekday = DateFormat.E()
                      .dateSymbols
                      .STANDALONEWEEKDAYS[(index + 1) % 7][0]
                      .toUpperCase();
                  return Expanded(
                    child: Center(
                      child: Text(
                        weekday,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),

            // Month Headers and their respective dates
            ...calendarDates.map((date) {
              final bool isMonthHeader =
                  date.day == 1; // If it's the first day of the month
              return Column(
                children: [
                  // Display Month Header only once before the dates
                  if (isMonthHeader)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        DateFormat.MMMM().format(
                            date), // Display Month Name (e.g., December)
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  // Date Containers for this month
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _buildDatesForMonth(date),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Generate the calendar's dates
  List<DateTime> _generateCalendar(DateTime start, DateTime end) {
    List<DateTime> dates = [];
    DateTime currentDate = start;
    while (currentDate.isBefore(end)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }
    return dates;
  }

  // Build Date containers for a given month
  List<Widget> _buildDatesForMonth(DateTime monthStartDate) {
    final List<Widget> dateContainers = [];
    final DateTime firstDateOfMonth =
        DateTime(monthStartDate.year, monthStartDate.month, 1);
    final int firstWeekday =
        firstDateOfMonth.weekday; // Weekday for the first day of the month

    // Fill the dates leading up to the first day of the month
    for (int i = 0; i < firstWeekday - 1; i++) {
      dateContainers.add(SizedBox(width: 40)); // Empty box for spacing
    }

    // Add the dates for the current month
    for (int day = 1; day <= _getDaysInMonth(monthStartDate); day++) {
      final DateTime date =
          DateTime(monthStartDate.year, monthStartDate.month, day);
      final _Phase phase = _getPhase(date);
      dateContainers.add(
        Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _getPhaseFillColor(date, phase),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getPhaseBorderColor(phase),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return dateContainers;
  }

  // Get the number of days in a month
  int _getDaysInMonth(DateTime monthStartDate) {
    final DateTime nextMonth = (monthStartDate.month == 12)
        ? DateTime(monthStartDate.year + 1, 1, 1)
        : DateTime(monthStartDate.year, monthStartDate.month + 1, 1);
    return nextMonth.subtract(Duration(days: 1)).day;
  }

  // Check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Get the phase of the cycle based on the date
  _Phase _getPhase(DateTime date) {
    if (widget.lastPeriodDate == null) {
      return _Phase.normal; // If no last period date, use normal colors
    }

    final int daysSinceLastPeriod =
        date.difference(widget.lastPeriodDate!).inDays % cycleDuration;

    if (daysSinceLastPeriod < periodDuration) {
      return _Phase.period;
    } else if (daysSinceLastPeriod < periodDuration + follicularDuration) {
      return _Phase.follicular;
    } else if (daysSinceLastPeriod <
        periodDuration + follicularDuration + ovulationDuration) {
      return _Phase.ovulation;
    } else {
      return _Phase.luteal;
    }
  }

  // Get the phase color fill for the date
  Color _getPhaseFillColor(DateTime date, _Phase phase) {
    if (date.isBefore(DateTime.now())) {
      switch (phase) {
        case _Phase.period:
          return Colors.pink.withOpacity(0.5);
        case _Phase.ovulation:
          return Colors.blue.withOpacity(0.5);
        default:
          return Colors.purple.withOpacity(0.5);
      }
    }
    return Colors.transparent;
  }

  // Get the border color for the phase
  Color _getPhaseBorderColor(_Phase phase) {
    switch (phase) {
      case _Phase.period:
        return Colors.pink;
      case _Phase.ovulation:
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }
}

// Phase Enum
enum _Phase { period, follicular, ovulation, luteal, normal }
