import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:intl/intl.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';

import 'package:suprsync/presentation/homepage/schedules/shedules_controller/available_shifts_controller.dart';

class DaysGrid extends StatefulWidget {
  final int currentYear;
  final int currentMonth;

  DaysGrid({required this.currentYear, required this.currentMonth});

  @override
  _DaysGridState createState() => _DaysGridState();
}

class _DaysGridState extends State<DaysGrid> {
  DateTime? startDate;
  DateTime? endDate;
  late ScrollController _scrollController;
  int daysInMonth = 0;
  DateTime? selectedDate;

  bool rangeSelection = false; // Track the selected day

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToCurrentDate();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ShiftController _shiftController = Get.find();
  void scrollToCurrentDate() {
    DateTime now = DateTime.now();
    if (now.year == widget.currentYear && now.month == widget.currentMonth) {
      int todayIndex = now.day - 1;
      double offset = todayIndex * 71; // Adjust based on item width and margins
      _scrollController
          .jumpTo(offset - MediaQuery.of(context).size.width / 2 + 16);
    }
  }

  // Get the number of days in the current month
  int getDaysInMonth() {
    final firstDayOfNextMonth = (widget.currentMonth < 12)
        ? DateTime(widget.currentYear, widget.currentMonth + 1, 1)
        : DateTime(widget.currentYear + 1, 1, 1);
    return firstDayOfNextMonth.subtract(Duration(days: 1)).day;
  }

  handleDaySelection(DateTime selectedDate) async {
    setState(() {
      // Toggle range selection
      if (rangeSelection && this.selectedDate == selectedDate) {
        // If the same date is selected again, unselect it
        rangeSelection = false;
        startDate = null;
        endDate = null;

        // Reset shift controller values to defaults
        _shiftController.from.value =
            DateTime(DateTime.now().year, DateTime.now().month, 1);
        _shiftController.to.value = DateTime(
          DateTime.now().year,
          DateTime.now().month + 1,
          1,
        ).subtract(Duration(seconds: 1));
      } else {
        // Select a new date
        rangeSelection = true;
        this.selectedDate = selectedDate;

        // Set startDate to 12:00 AM of the selected date
        startDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);

        // Set endDate to 11:59 PM of the selected date
        endDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, 23, 59, 59);

        // Update the shift controller values
        _shiftController.from.value = startDate!;
        _shiftController.to.value = endDate!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = getDaysInMonth();

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        int day = index + 1;
        DateTime date = DateTime(widget.currentYear, widget.currentMonth, day);

        bool isToday = date.day == DateTime.now().day &&
            date.month == DateTime.now().month &&
            date.year == DateTime.now().year;
        bool isSelected =
            selectedDate != null && selectedDate == date && rangeSelection;

        return Obx(() {
          print(_shiftController.from.value);
          return GestureDetector(
            onTap: () async {
              await handleDaySelection(date);
              // Updating values safely
              setState(() {
                selectedDate = date; // Update the selected date
              });
              _shiftController.fetchAvailableShift();

              // startDate != null ? _shiftController
            },
            child: Column(
              children: [
                DayContainer(
                  day: day,
                  date: date,
                  isToday: isToday,
                  isSelected: isSelected,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 4, color: Colors.grey),
                    SizedBox(width: 2),
                    Icon(Icons.circle, size: 4, color: Colors.grey),
                    SizedBox(width: 2),
                    Icon(Icons.circle, size: 4, color: Colors.grey),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class DayContainer extends StatelessWidget {
  final int day;
  final DateTime date;
  final bool isToday;
  final bool isSelected;

  const DayContainer({
    required this.day,
    required this.date,
    required this.isToday,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected
            ? Color(0xffEAFFF4)
            : isToday
                ? Color(0xffEAFFF4)
                : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? Color(0xff3E9979)
              : isToday
                  ? Color(0xff3E9979)
                  : Color(0xffE7E7E7),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.E().format(date),
            style: context.textTheme.bodyMedium?.copyWith(
              color: isToday
                  ? Color(0xff939292)
                  : isSelected
                      ? Color(0xff03552C)
                      : Color(0xffC7C5C5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day.toString(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: isToday
                  ? const Color(0xff03552C)
                  : isSelected
                      ? Color(0xff03552C)
                      : Color(0xffB5B5B5),
            ),
          ),
        ],
      ),
    );
  }
}
