import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/date_utils.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/models/shifts_model.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/homepage/calendar/calendar_controller.dart';
import 'package:suprsync/presentation/homepage/schedules/shedules_controller/available_shifts_controller.dart';
import 'package:suprsync/presentation/homepage/schedules/widgets/days_grid.dart';
import 'package:suprsync/presentation/homepage/schedules/widgets/search_field.dart';
import 'package:suprsync/presentation/homepage/widgets/swap_cards.dart';

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
  final AuthController _authController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    showLoading();
    _shiftController.fetchAvailableShift();
    Get.back();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SmartRefresher(
      onRefresh: _pullRefresh,
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      onLoading: _onLoading,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BirthCalendarMonth(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 44,
                ),
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
                            ? const Icon(
                                Icons.filter_alt) // For when filter is applied
                            : const Icon(
                                Icons.filter), // For when filter is not applied
                        onPressed: () {
                          _shiftController.filterApplied.value =
                              !_shiftController.filterApplied.value;
                          _shiftController.fetchAvailableShift();
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
                const SizedBox(
                  height: 17,
                ),
                const CustomSearchField(
                  hint: 'Search',
                  preficIcon: Icon(
                    Icons.search,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    monthYear,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: DaysGrid(
                      currentYear: currentYear, currentMonth: currentMonth),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (_shiftController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    print(_shiftController.shiftsModel);

                    // print(_shiftController.shiftsModel.first.start);
                    return _shiftController.shiftsModel.isEmpty
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
                                itemCount: _shiftController.shiftsModel.length,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var shift =
                                      _shiftController.shiftsModel[index];
                                  // Initialize variables for the day and time
                                  String dayOfWeek = "Invalid Date";
                                  String timeRange = "Unavailable";
                                  String hoursWorked = "invalid date";
                                  String duration = "invalid date";
                                  String month = "invalid date";
                                  String hexCode = '0xff26BFBF';
                                  print(shift.slot!.branch!.hexcode);
                                  try {
                                    // Attempt to parse the start date
                                    DateTime parsedDate =
                                        DateTime.parse(shift.start.toString());

                                    // Format the DateTime to get the full day name
                                    dayOfWeek =
                                        DateFormat('EEEE').format(parsedDate);
                                  } catch (e) {}

                                  // Check if slot details are valid
                                  if (shift.slot != null) {
                                    timeRange =
                                        '${shift.slot!.startTime} - ${shift.slot!.endTime}';
                                    hoursWorked = calculateHours(
                                        shift.slot!.startTime!,
                                        shift.slot!.endTime!);
                                    duration = formatTimeRange(
                                        shift.slot!.startTime!,
                                        shift.slot!.endTime!);
                                    hexCode =
                                        '0xff${shift.slot!.branch!.hexcode!.substring(
                                      1,
                                    )}';
                                    // month = monthFormatter(
                                    //     "${clockController.pastScheduleModel[index].createdOn}");
                                  }
                                  String initials =
                                      '${shift.user?.firstName.toString().substring(0, 1)} ${shift.user?.lastName.toString().substring(0, 1)}';
                                  return dayOfWeek != "Invalid Date" &&
                                          shift.swappable == false
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
                                      : const SizedBox
                                          .shrink(); // Skip invalid entries
                                },
                              ),
                              // Visibility(
                              //   visible:
                              //       _shiftController.shiftsModel.isNotEmpty,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(
                              //         left: 20.0, top: 20),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           'Open shifts for swap',
                              //           style: context.textTheme.bodyMedium
                              //               ?.copyWith(
                              //                   fontWeight: FontWeight.w700,
                              //                   color: Color(0xffD9694D)),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Visibility(
                              //     visible: _shiftController
                              //         .swappableShiftsModel.isNotEmpty,
                              //     child: ListView.builder(
                              //       padding: EdgeInsets.zero,
                              //       itemCount: _shiftController
                              //           .swappableShiftsModel.length,
                              //       shrinkWrap: true,
                              //       physics: NeverScrollableScrollPhysics(),
                              //       // reverse: true,
                              //       itemBuilder: (context, index) {
                              //         var shift = _shiftController
                              //             .swappableShiftsModel[index];
                              //         // Initialize variables for the day and time
                              //         String dayOfWeek = "Invalid Date";
                              //         String timeRange = "Unavailable";
                              //         String hoursWorked = "invalid date";
                              //         String duration = "invalid date";
                              //         String month = "invalid date";
                              //         String hexCode = '0xff26BFBF';
                              //         print(shift.slot!.branch!.hexcode);
                              //         try {
                              //           // Attempt to parse the start date
                              //           DateTime parsedDate = DateTime.parse(
                              //               shift.start.toString());

                              //           // Format the DateTime to get the full day name
                              //           dayOfWeek = DateFormat('EEEE')
                              //               .format(parsedDate);
                              //         } catch (e) {}

                              //         // Check if slot details are valid
                              //         if (shift.slot != null) {
                              //           timeRange =
                              //               '${shift.slot!.startTime} - ${shift.slot!.endTime}';
                              //           hoursWorked = calculateHours(
                              //               shift.slot!.startTime!,
                              //               shift.slot!.endTime!);
                              //           duration = formatTimeRange(
                              //               shift.slot!.startTime!,
                              //               shift.slot!.endTime!);
                              //           hexCode =
                              //               '0xff${shift.slot!.branch!.hexcode!.substring(
                              //             1,
                              //           )}';
                              //           // month = monthFormatter(
                              //           //
                              //           //   "${clockController.pastScheduleModel[index].createdOn}");
                              //         }
                              //         String initials =
                              //             '${shift.user?.firstName.toString().substring(0, 1)}${shift.user?.lastName.toString().substring(0, 1)}';
                              //         return dayOfWeek != "Invalid Date" &&
                              //                 shift.swappable == true
                              //             ? SwapCard(
                              //                 isActive: true,
                              //                 day: dayOfWeek,
                              //                 time: duration,
                              //                 id: shift.id.toString(),
                              //                 title:
                              //                     '${shift.user?.firstName ?? "Unknown"} ${shift.user?.lastName ?? ""}',
                              //                 isOpenForSwap:
                              //                     shift.swappable ?? false,
                              //                 branch: shift.slot!.branch!.name
                              //                     .toString(),
                              //                 hexcode: hexCode,
                              //                 initials: initials,
                              //               )
                              //             : const SizedBox
                              //                 .shrink(); // Skip invalid entries
                              //       },
                              //     ))
                            ],
                          );
                  }),
                ],
              ),
            ),
          ),

          // const Spacer()
          // ,
        ],
      ),
    );
  }
}
