// ignore_for_file: unnecessary_string_interpolations

import 'package:easy_count_timer/easy_count_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/date_utils.dart';
import 'package:suprsync/presentation/dashboard_screen/account_information/account_information_page.dart';
import 'package:suprsync/presentation/dashboard_screen/schedules/shedules_controller/available_shifts_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/widgets/next_shifts.dart';
import 'package:suprsync/presentation/location_clockin_screen.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/clockin_page/clockin_controller.dart';
import 'package:suprsync/util/extensions/string.dart';

class ClockInPage extends StatefulWidget {
  const ClockInPage({super.key, this.id});
  final String? id;
  @override
  State<ClockInPage> createState() => _ClockInPageState();
}

var controller = CountTimerController();
bool isActive = false;

class _ClockInPageState extends State<ClockInPage> {
  AuthController authController = Get.find();
  ClockInAndOutController clockController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;
  final ShiftController _shiftController = Get.find();
  String? wifiName;

  String get monthYear => DateFormat.yMMMM().format(DateTime.now());

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) _refreshController.loadComplete();
  }

  DateTime now = DateTime.now();
  final String monthDuration = formatDynamicDateRange();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leadingWidth: 20,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.green,
            child: Image.asset(
              AppIcons.collins,
            ),
          ),
        ),

        title: Obx(() {
          return Text(
            '${authController.firstName.value.getFirstLetters()} ${authController.lastName.value.getFirstLetters()}.',
            style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xff414141),
                fontSize: 14),
          );
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: Image.asset(
              AppIcons.notifications,
              height: 18,
              color: const Color(0xff414141),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const AccountInformationPage(
                  // userAuth: widget.userAuth
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 20.0, left: 20, top: 20, bottom: 20),
              child: Image.asset(
                AppIcons.menu,
                height: 18,
                color: const Color(0xff414141),
              ),
            ),
          ),
        ],
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
                const SizedBox(
                  height: 20,
                ),
                Text('Dashboard',
                    style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff414141),
                        fontSize: 16)),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppIcons.shiftsCard),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xffF5F5F5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(AppIcons.clockFilled),
                            const SizedBox(width: 8),
                            Text(
                              'Shifts',
                              style: context.textTheme.labelMedium
                                  ?.copyWith(color: const Color(0xff717680)),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          final nextShift = _shiftController.nextShift;
                          return Text(
                            nextShift != null
                                ? TimeUtils.getShiftStartText(
                                    DateTime.parse(nextShift.start.toString()))
                                : 'No upcoming shifts',
                            style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff414141),
                                fontSize: 18),
                          );
                        }),
                        Obx(() {
                          final nextShift = _shiftController.nextShift;
                          final slot = nextShift?.slot;

                          if (slot?.startTime != null &&
                              slot?.endTime != null) {
                            final timeRange = TimeUtils.formatTimeRange(
                                slot!.startTime!, slot.endTime!);
                            final branchName = slot.branch?.name ?? 'Unknown';

                            return Text(
                              '$timeRange at $branchName',
                              style: context.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff414141),
                                  fontSize: 14),
                            );
                          } else {
                            return Text(
                              'No shift details available',
                              style: context.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff414141),
                                  fontSize: 14),
                            );
                          }
                        }),
                        const SizedBox(height: 4),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 150,
                          child: RectangularButton(
                            verticalPadding: 0,
                            onPress: () {
                              Get.to(() => Obx(() {
                                    return LocationClockinScreen(
                                      clockInType: 'clockIn',
                                      shiftId: _shiftController.nextShift?.id
                                              .toString() ??
                                          widget.id.toString(),
                                    );
                                  }));
                            },
                            buttonTitle: 'Clock In',
                            textStyleColor: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            colour: context.colorScheme.tertiary,
                            height: 34,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 16, top: 18.5, bottom: 16, right: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffF5F5F5), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.request,
                                  height: 16.6,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Requests',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff26BFBF)),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Send and keep track of your requests all in one place',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff414141)),
                            ),
                            const SizedBox(height: 24),
                            TransparentRectangularButton(
                              onPress: () {
                                // Get.back();
                                // Add your login logic here
                              },
                              buttonTitle: 'Create',
                              textStyleColor: context.textTheme.labelLarge
                                  ?.copyWith(
                                      color: const Color(0xff26BFBF),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                              colour: const Color(0xff26BFBF),
                              // horizontalPadding: 12,
                              // verticalPadding: 8,
                              height: 32,
                              width: 67,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 16, top: 18.5, bottom: 16, right: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffF5F5F5), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.inventory,
                                  height: 16.6,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Inventory',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff717680)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'View order requests and transfer items',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff414141)),
                            ),
                            const SizedBox(height: 40),
                            TransparentRectangularButton(
                              onPress: () {
                                Get.back();
                              },
                              buttonTitle: 'View',
                              textStyleColor: context.textTheme.labelLarge
                                  ?.copyWith(
                                      color: const Color(0xff717680),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                              colour: const Color(0xff717680),
                              height: 32,
                              width: 55,
                            ),
                          ],
                        ),
                      ),
                    ),
                    //
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Next shifts',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff414141)),
                ),
                const SizedBox(height: 10),
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
                          return _shiftController.upcomingShifts.isEmpty
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
                                      itemCount: _shiftController
                                          .upcomingShifts.length,
                                      reverse: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final shift = _shiftController
                                            .upcomingShifts[index];
                                        // ✅ Parse date safely
                                        DateTime? parsedDate;
                                        String dayOfWeek = "Invalid Date";
                                        String duration = "Unavailable";
                                        try {
                                          parsedDate = DateTime.parse(
                                              shift.start.toString());
                                          dayOfWeek = DateFormat('EEEE')
                                              .format(parsedDate);
                                        } catch (e) {}
                                        final slot = shift.slot!;
                                        final branch = slot.branch!;

                                        duration = formatTimeRange(
                                            slot.startTime!, slot.endTime!);
                                        final hexCode =
                                            '${branch.hexcode!.substring(1)}';

                                        return ShiftCard(
                                          day: dayOfWeek,
                                          time: duration,
                                          id: shift.id.toString(),
                                          branch: shift.slot!.branch!.name
                                              .toString(),
                                          hexCode: hexCode,
                                        );
                                        // : const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getShiftStartText(DateTime start) {
    final now = DateTime.now();
    final diff = start.difference(now);

    if (diff.isNegative) return "Shift started";
    if (diff.inMinutes < 1) return "Starts now";
    if (diff.inMinutes < 60) {
      final mins = diff.inMinutes;
      return "Starts in $mins minute${mins > 1 ? 's' : ''}";
    }
    if (diff.inHours < 24) {
      final hours = diff.inHours;
      return "Starts in $hours hour${hours > 1 ? 's' : ''}";
    }
    if (diff.inDays == 1) return "Starts tomorrow";
    if (diff.inDays < 7) return "Starts in ${diff.inDays} days";
    if (diff.inDays < 14) return "Starts in 1 week";
    return "Starts in ${(diff.inDays / 7).round()} weeks";
  }
}
