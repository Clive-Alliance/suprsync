import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:intl/intl.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';

import 'package:suprsync/presentation/dashboard_screen/schedules/shedules_controller/available_shifts_controller.dart';

class DaysGrid extends StatefulWidget {
  final int currentYear;
  final int currentMonth;

  const DaysGrid(
      {super.key, required this.currentYear, required this.currentMonth});

  @override
  State<DaysGrid> createState() => _DaysGridState();
}

class _DaysGridState extends State<DaysGrid> {
  DateTime? startDate;
  DateTime? endDate;
  late ScrollController _scrollController;
  int daysInMonth = 0;
  DateTime? selectedDate;

  bool rangeSelection = false;

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

  final ShiftController _shiftController = Get.find();
  void scrollToCurrentDate() {
    DateTime now = DateTime.now();
    if (now.year == widget.currentYear && now.month == widget.currentMonth) {
      int todayIndex = now.day - 1;
      double offset = todayIndex * 71;
      _scrollController
          .jumpTo(offset - MediaQuery.of(context).size.width / 2 + 16);
    }
  }

  int getDaysInMonth() {
    final firstDayOfNextMonth = (widget.currentMonth < 12)
        ? DateTime(widget.currentYear, widget.currentMonth + 1, 1)
        : DateTime(widget.currentYear + 1, 1, 1);
    return firstDayOfNextMonth.subtract(const Duration(days: 1)).day;
  }

  handleDaySelection(DateTime selectedDate) async {
    setState(() {
      if (rangeSelection && this.selectedDate == selectedDate) {
        rangeSelection = false;
        startDate = null;
        endDate = null;

        _shiftController.from.value =
            DateTime(DateTime.now().year, DateTime.now().month, 1);
        _shiftController.to.value = DateTime(
          DateTime.now().year,
          DateTime.now().month + 1,
          1,
        ).subtract(const Duration(seconds: 1));
      } else {
        rangeSelection = true;
        this.selectedDate = selectedDate;

        startDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);

        endDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, 23, 59, 59);

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
          final shifts =
              _shiftController.from.value; // or whatever data you need

          return GestureDetector(
            onTap: () async {
              await handleDaySelection(date);

              setState(() {
                selectedDate = date;
              });
              _shiftController.fetchAllShifts();
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
    super.key,
    required this.day,
    required this.date,
    required this.isToday,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xffEAFFF4)
            : isToday
                ? const Color(0xffEAFFF4)
                : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? const Color(0xff3E9979)
              : isToday
                  ? const Color(0xff3E9979)
                  : const Color(0xffE7E7E7),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.E().format(date),
            style: context.textTheme.bodyMedium?.copyWith(
              color: isToday
                  ? const Color(0xff939292)
                  : isSelected
                      ? const Color(0xff03552C)
                      : const Color(0xffC7C5C5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day.toString(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: isToday
                  ? const Color(0xff03552C)
                  : isSelected
                      ? const Color(0xff03552C)
                      : const Color(0xffB5B5B5),
            ),
          ),
        ],
      ),
    );
  }
}
