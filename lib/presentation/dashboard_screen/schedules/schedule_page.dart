import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:intl/intl.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/date_utils.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/presentation/dashboard_screen/calendar/calendar_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/schedules/shedules_controller/available_shifts_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/schedules/widgets/days_grid.dart';
import 'package:suprsync/presentation/dashboard_screen/schedules/widgets/search_field.dart';
import 'package:suprsync/presentation/dashboard_screen/widgets/swap_cards.dart';
import 'package:suprsync/services/bloc/clockin.dart';
import 'package:suprsync/util/extensions/date.dart';

import '../../../models/event_schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;

  String get monthYear => DateFormat.yMMMM().format(DateTime.now());
  final ShiftController _shiftController = Get.find();
  final CalendarController _calendarController = Get.find();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final ClockInBloc _bloc = ClockInBloc();
  DateTime selectedDate = DateTime.now();

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    showLoading();
    _shiftController.fetchAllShifts();
    Get.back();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) _refreshController.loadComplete();
  }

  void bindBloc(){
    _bloc.shiftSchedule(from: selectedDate);
    // _bloc.offDays(from: selectedDate);
  }

  @override
  void initState() {
    bindBloc();
    super.initState();
    _calendarController.updateTodaysDate();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      onRefresh: _pullRefresh,
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      onLoading: _onLoading,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BirthCalendarMonth(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 560,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Schedules',
                          style: context.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff2C2C2C)),
                        ),
                        Obx(() {
                          return IconButton(
                            icon: _shiftController.filterApplied.value
                                ? const Icon(Icons.filter_alt)
                                : const Icon(Icons.filter),
                            onPressed: () {
                              _shiftController.toggleFilter();
                            },
                          );
                        })
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text('See all assigned schedules here',
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: const Color(0xff616161))),
                    const CustomSearchField(
                      hint: 'Search',
                      preficIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                      child: StreamBuilder(
                        stream: _bloc.shiftScheduleResponse,
                        builder: (context, asyncSnapshot) {
                          List<EventSchedule>? schedules = asyncSnapshot.data;
                          schedules?.map((toElement)=> print(toElement.shiftName));
                          return SizedBox(
                            height: 500,
                            child: MonthView(
                              controller: EventController(),
                              // to provide custom UI for month cells.
                              cellBuilder: (
                                  date,
                                  events,
                                  isToday,
                                  isInMonth,
                                  hideDaysNotInMonth,
                                  ) {
                                return Column(
                                  children: [
                                    Text(date.day.toString()),
                                    isToday
                                        ? Text('Today', style: context.textTheme.bodySmall?.copyWith(color: const Color(0xff616161), fontSize: 6))
                                        : SizedBox(),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: schedules?.length ?? 0,
                                          itemBuilder: (context, index){
                                        return schedules?[index].start?.formatDateTime(format: 'YYYY-MM-dd') == date.formatDateTime(format: 'YYYY-MM-dd')
                                            ? Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.green.withValues(alpha: 0.3),
                                                borderRadius: BorderRadius.circular(2)
                                            ),
                                            child: Center(
                                              child: Text(
                                                schedules?[index].shiftName ?? '',
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style: context.textTheme.bodySmall?.copyWith(color: Colors.black, fontSize: 8),
                                              ),
                                            ),
                                          ),
                                        )
                                            : SizedBox();
                                      }),
                                    ),
                                  ],
                                );
                              },
                              minMonth: DateTime(1990),
                              maxMonth: DateTime(2100),
                              initialMonth: DateTime.now(),
                              cellAspectRatio: 1,
                              onPageChange: (date, pageIndex){
                                selectedDate = date;
                                _bloc.shiftSchedule(from: selectedDate);
                                // _bloc.offDays(from: selectedDate);
                              },
                              onCellTap: (events, date) {
                                // Implement callback when user taps on a cell.
                                print(events);
                              },
                              startDay: WeekDays.monday,
                              // To change the first day of the week.
                              // This callback will only work if cellBuilder is null.
                              onEventTap: (event, date) => print(event),
                              onEventDoubleTap: (events, date) => print(events),
                              onEventLongTap: (event, date) => print(event),
                              onDateLongPress: (date) => print(date),
                              headerBuilder: (date)=> Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.keyboard_arrow_left_sharp),
                                    Text(
                                      date.formatDateTime(format: 'MMMM yyyy'),
                                      style: context.textTheme.bodyMedium,
                                    ),
                                    Icon(Icons.keyboard_arrow_right_sharp),
                                  ],
                                ),
                              ),
                              // To hide month header
                              showWeekTileBorder: true,
                              // To show or hide header border
                              hideDaysNotInMonth: true,
                              // To hide days or cell that are not in current month
                              showWeekends: true, // To hide weekends default value is true
                            ),
                          );
                        }
                      ),
          
                      // DaysGrid(currentYear: currentYear, currentMonth: currentMonth),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20),
                decoration: const BoxDecoration(
                    color: Color(0xff056033),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                height: 48,
                child: Row(
                  // mainAxisAlignment: Main,
                  children: [
                    Image.asset(
                      AppIcons.dot,
                      height: 8,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Obx(() {
                      return Text(
                        _calendarController.todaysDate.value,
                        style: context.textTheme.bodySmall!.copyWith(
                          color: const Color(0xffffffff),
                        ),
                      );
                    })
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      if (_shiftController.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final currentShifts = _shiftController.currentShifts;
        
                      return currentShifts.isEmpty
                          ? const Center(
                              child: Text(
                                'No shift available.',
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          : Column(
                              children: [
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: currentShifts.length,
                                  reverse: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var shift =
                                        currentShifts[index]; // Simplified
        
                                    String dayOfWeek = "Invalid Date";
        
                                    String duration = "invalid date";
                                    String hexCode = '0xff26BFBF';
                                    try {
                                      DateTime parsedDate =
                                          DateTime.parse(shift.start.toString());
        
                                      dayOfWeek =
                                          DateFormat('EEEE').format(parsedDate);
                                    } catch (e) {}
        
                                    if (shift.slot != null) {
                                      duration = formatTimeRange(
                                          shift.slot!.startTime!,
                                          shift.slot!.endTime!);
                                      hexCode =
                                          '0xff${shift.slot!.branch!.hexcode!.substring(
                                        1,
                                      )}';
                                    }
                                    String initials =
                                        '${shift.user?.firstName.toString().substring(0, 1)} ${shift.user?.lastName.toString().substring(0, 1)}';
                                    return dayOfWeek != "Invalid Date"
                                        ? SwapCard(
                                            isActive: true,
                                            day: dayOfWeek,
                                            time: duration,
                                            id: shift.id.toString(),
                                            title:
                                                '${shift.user?.firstName ?? "Unknown"} ${shift.user?.lastName ?? ""}',
                                            isOpenForSwap:
                                                shift.swappable ?? false,
                                            branch: shift.slot!.branch!.name
                                                .toString(),
                                            hexcode: hexCode,
                                            initials: initials,
                                          )
                                        : const SizedBox.shrink();
                                  },
                                ),
                              ],
                            );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
