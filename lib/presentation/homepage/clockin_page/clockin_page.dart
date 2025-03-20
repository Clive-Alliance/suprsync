import 'package:easy_count_timer/easy_count_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/date_utils.dart';
import 'package:suprsync/presentation/face_detection_screen.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/homepage/clockin_page/clockin_controller.dart';

import 'package:suprsync/presentation/homepage/clockin_page/widgets/checkin_list_tile.dart';
import 'package:suprsync/presentation/homepage/clockin_page/widgets/clockout_bottom_sheet.dart';
import 'package:suprsync/presentation/homepage/withdrawal/withdrawal_screen.dart';

class ClockInPage extends StatefulWidget {
  const ClockInPage({super.key, required this.id});
  final String id;
  @override
  State<ClockInPage> createState() => _ClockInPageState();
}

var controller = CountTimerController();
bool isActive = false; // Variable to toggle

class _ClockInPageState extends State<ClockInPage> {
  AuthController authController = Get.find();
  ClockInAndOutController clockController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // Function to toggle the variable
  void toggleActiveState(state) {
    setState(() {
      isActive = !isActive;
    });
    if (state == 'Clock In' && isActive == true) {
      controller.start();
    } else if (state == 'Take a break' && isActive == false) {
      controller.pause();
    } else if (state == 'Confirm' && isActive == false) {
      controller.stop();
    }
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    clockController.getClockInSchedule();
    // Get.back();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) _refreshController.loadComplete();
  }

  DateTime now = DateTime.now(); // Example date
  final String monthDuration = formatDynamicDateRange();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showWithdrawalSheet(context);
        },
        backgroundColor: const Color(0xFF00AD57),
        child: Image.asset(
          AppIcons.transfer,
          height: 18,
        ),
      ),
      body: SmartRefresher(
        onRefresh: _pullRefresh,
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onLoading: _onLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // const SizedBox(
                //   height: 20,
                // ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.close_outlined))
                  ],
                ),
                // Obx(() {
                //   return
                !isActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Text(
                              'Welcome ${authController.firstName.value},',
                              style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff727272),
                                  fontSize: 14),
                            );
                          }),

                          // }),
                          Text('Let’s get to work!',
                              style: context.textTheme.titleMedium),

                          const SizedBox(
                            height: 20,
                          ),
                          RectangularButton(
                            verticalPadding: 0,
                            onPress: () {
                              Get.to(() => FaceDetentionScreen(
                                  clockInType: 'clockIn',
                                  shiftId: widget.id.toString(),
                                  onReply: toggleActiveState));
                            },
                            buttonTitle: 'Clock In',
                            textStyleColor: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            colour: context.colorScheme.tertiary,
                            height: 50,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDateWithOrdinal(now),
                            style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff727272),
                                fontSize: 14),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('You are Clocked in',
                              style: context.textTheme.titleMedium),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('Clocked in for:',
                                  style: context.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff727272),
                                      fontSize: 14)),
                              CountTimer(
                                format: CountTimerFormat.hoursMinutes,
                                enableDescriptions: false,
                                timeTextStyle:
                                    context.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w500,
                                ),
                                spacerWidth: 0,
                                controller: controller,
                              ),
                              Text('hrs',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RectangularButton(
                            verticalPadding: 0,
                            onPress: () {
                              // Get.to(() => FaceDetentionScreen(
                              //     clockInType: 'clockOut',
                              //     shiftId: widget.id.toString(),
                              //     onReply: toggleActiveState));
                              showClockOutBottomSheet(context,
                                  toggleActiveState, controller.duration);
                            },
                            buttonTitle: 'Clock Out',
                            textStyleColor: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            colour: context.colorScheme.tertiary,
                            height: 50,
                          ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       flex: 2,
                          //       child: RectangularButton(
                          //         verticalPadding: 0,
                          //         onPress: () {
                          //           toggleActiveState('Take a break');
                          //           // Get.to(() => ScanFacePage());
                          //         },
                          //         buttonTitle: 'Take a break',
                          //         textStyleColor: const TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //         colour: context.colorScheme.tertiary,
                          //         height: 50,
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //     Expanded(
                          //       flex: 2,
                          //       child: TransparentRectangularButton(
                          //         verticalPadding: 0,
                          //         onPress: () {
                          //           showClockOutBottomSheet(
                          //               context, toggleActiveState);
                          //         },
                          //         buttonTitle: 'Clock out',
                          //         textStyleColor: const TextStyle(
                          //           color: Color(0xff000000),
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //         // colour: Colors.transparent,
                          //         height: 50,
                          //       ),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),

                Container(
                  color: const Color(0xffF9F8F8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/refresh.png',
                            width: 17,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text('Total working hour',
                              style: context.textTheme.labelLarge),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 27, right: 17, top: 21),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Today',
                                    style:
                                        context.textTheme.labelMedium?.copyWith(
                                      color: const Color(0xff727272),
                                    )),
                                Row(
                                  children: [
                                    isActive
                                        ? CountTimer(
                                            format:
                                                CountTimerFormat.hoursMinutes,
                                            enableDescriptions: false,
                                            timeTextStyle: context
                                                .textTheme.bodyMedium
                                                ?.copyWith(
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            spacerWidth: 0,
                                            controller: controller,
                                          )
                                        : Text('00:00',
                                            style: context.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w500,
                                            )),
                                    const SizedBox(
                                      width: 1,
                                    ),
                                    Text('Hrs',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 41,
                              child: VerticalDivider(
                                  thickness: 2, color: Color(0xffE9E8E8)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'This pay period',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                          color: const Color(0xff727272)),
                                ),
                                Text('40:00Hrs',
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Current pay period',
                                  style:
                                      context.textTheme.labelMedium?.copyWith(
                                    color: const Color(0xff727272),
                                  )),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(monthDuration,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffE4FFF1),
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          color: const Color(0xff00AD57),
                                          width: 0.5)),
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xff056033),
                                  ),
                                ),
                                Text(
                                  'Add Time',
                                  style: context.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xff000000)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    return clockController.pastScheduleModel.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No past Schedules'),
                            ],
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: clockController.pastScheduleModel.length,
                            itemBuilder: (context, index) {
                              var clockinSchedules =
                                  clockController.pastScheduleModel[index];

                              String dayOfWeek = "Invalid Date";
                              String timeRange = "Unavailable";
                              String hoursWorked = 'invalid';
                              String duration = 'invalid';
                              String month = 'invalid';

                              try {
                                // Attempt to parse the start date
                                DateTime parsedDate = DateTime.parse(
                                    clockinSchedules.start.toString());

                                // Format the DateTime to get the full day name
                                dayOfWeek =
                                    DateFormat('EEEE').format(parsedDate);
                              } catch (e) {}

                              // Check if slot details are valid
                              if (clockinSchedules.slot != null) {
                                timeRange =
                                    '${clockinSchedules.slot!.startTime}  - ${clockinSchedules.slot!.endTime}';

                                hoursWorked = calculateHours(
                                    clockinSchedules.slot!.startTime!,
                                    clockinSchedules.slot!.endTime!);
                                duration = formatTimeRange(
                                    clockinSchedules.slot!.startTime!,
                                    clockinSchedules.slot!.endTime!);
                                month = monthFormatter(
                                    "${clockController.pastScheduleModel[index].createdOn}");
                              }
                              return Visibility(
                                visible: hoursWorked != 'invalid',
                                child: CheckinListTile(
                                    checkInScheduleModel: clockController
                                        .pastScheduleModel[index],
                                    range: timeRange,
                                    hoursWorked: hoursWorked,
                                    duration: duration,
                                    month: month),
                              );
                            });
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showWithdrawalSheet(BuildContext context) {
    // final ValueCallback onValueSelected;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    // AuthController _authController = AuthController();
    bool isVisible = false;

    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: context.colorScheme.secondary,
        context: context,
        builder: (BuildContext context) {
          return WithdrawalSheetSheet(
              // emailController: _emailController,
              // // isVisible: isVisible,
              // passwordController: _passwordController,
              // authController: _authController
              );
        });
  }
}

void showClockOutBottomSheet(
    BuildContext context, toggleActiveState, duration) {
  // AuthController _authController = AuthController();

  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: context.colorScheme.secondary,
      context: context,
      builder: (BuildContext context) {
        return ClockoutBottomSheet(
            onToggle: toggleActiveState, duration: duration);
      });
}

String formatDateWithOrdinal(DateTime date) {
  // Get day with ordinal suffix
  String dayWithSuffix = '${date.day}${getOrdinalSuffix(date.day)}';

  // Format month and day name
  String formattedDate = DateFormat('EEEE, MMM').format(date);

  // Append year
  String year = DateFormat('y').format(date);

  // Combine all parts
  return '$formattedDate $dayWithSuffix, $year';
}

String getOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
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


//nlp-tracker.herokuapp.com/api/v1/shifts/9a07a1d8-e289-4db5-bb2b-8df4bd15be11/admin-clock-in-or-out