import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:local_auth/local_auth.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/presentation/dashboard_screen/clockin_page/clockin_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/clockin_page/widgets/clockin_action_circle.dart';
import 'package:suprsync/presentation/dashboard_screen/clockin_page/widgets/info_card.dart';

typedef StringToVoidFunc = void Function(String);

class LocationClockinScreen extends StatefulWidget {
  const LocationClockinScreen({
    super.key,
    required this.clockInType,
    required this.shiftId,
  });

  final String clockInType;
  final String shiftId;

  @override
  State<LocationClockinScreen> createState() => _LocationClockinScreenState();
}

class _LocationClockinScreenState extends State<LocationClockinScreen> {
  ClockInAndOutController clockInController = Get.find();

  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  'assets/icons/arrow-left.png',
                  width: 20,
                  color: const Color(0xff414141),
                  // height: 18,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          'Clock in',
          style: context.textTheme.bodyLarge
              ?.copyWith(fontSize: 16, color: const Color(0xff414141)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xffFCFCFD),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffEBFFF3),
                        spreadRadius: 4,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'With location',
                        style: context.textTheme.labelLarge
                            ?.copyWith(color: const Color(0xff535862)),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Container(
                          decoration: const BoxDecoration(
                              color: Color(0xffECFDF3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.33, vertical: 3),
                          child: Image.asset(
                            AppIcons.location,
                            // height: 16.6,
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xffFCFCFD),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x207A7A7A),
                        spreadRadius: 4,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'With barcode',
                        style: context.textTheme.labelLarge
                            ?.copyWith(color: const Color(0xff535862)),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Container(
                          decoration: const BoxDecoration(
                              color: Color(0x207A7A7A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.33, vertical: 3),
                          child: Image.asset(
                            AppIcons.scanBarcodeFilled,
                            color: const Color(0xff414141),
                            // height: 16.6,
                          ))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 32,
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
                    _CurrentTime(),
                    const SizedBox(height: 12),
                    Obx(() {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 17.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: clockInController.status.value ==
                                      ShiftStatus.clockingIn ||
                                  clockInController.status.value ==
                                      ShiftStatus.onBreak
                              ? const Color(0xffECFDF3)
                              : const Color(0xffFCFCFD),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: clockInController.status.value ==
                                          ShiftStatus.clockingIn ||
                                      clockInController.status.value ==
                                          ShiftStatus.onBreak
                                  ? const Color(0x24C6FADB)
                                  : const Color(0x207A7A7A),
                              spreadRadius: 4,
                              // blurRadius: 3, // Slight blur for softer look
                              offset:
                                  const Offset(0, 1), // Slight downward shadow
                            ),
                          ],
                        ),
                        child: Obx(() {
                          return Text(
                            clockInController.statusText,
                            style: context.textTheme.labelLarge?.copyWith(
                                color: clockInController.status.value ==
                                            ShiftStatus.clockingIn ||
                                        clockInController.status.value ==
                                            ShiftStatus.onBreak
                                    ? const Color(0xff05603A)
                                    : const Color(0xff535862)),
                          );
                        }), // your button content
                      );
                    }),
                  ],
                ),
              ),
            ),
            // _buildTimerDisplay(),
            const SizedBox(height: 32),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffF5F5F5)),
              ),
              child: Obx(() {
                if (clockInController.status.value == ShiftStatus.clockingIn) {
                  // When clocked in: show Clock Out (press-and-hold) and Break (tap) buttons
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionCircle(
                        icon: AppIcons.pause, // Use stop icon if available
                        label: "Clock out",
                        onComplete:
                            clockInController.attemptClockOut, // Press and hold
                        text: clockInController.timerText.value,
                      ),
                      ActionCircle(
                        icon: AppIcons.play,
                        label: "Break",
                        onComplete: clockInController.startBreak,
                        text: clockInController.breakTimerText.value,
                        // Simple tap
                      ),
                    ],
                  );
                } else if (clockInController.status.value ==
                    ShiftStatus.onBreak) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionCircle(
                        icon: AppIcons.pause, // Use stop icon if available
                        label: "Clock out",
                        onComplete:
                            clockInController.attemptClockOut, // Press and hold
                        text: clockInController.timerText.value,
                      ),
                      ActionCircle(
                        icon: AppIcons.play, // Use resume icon if available
                        label: "End Break",
                        onComplete: clockInController.endBreak,
                        text: clockInController
                            .breakTimerText.value, // Simple tap
                      ),
                    ],
                  );
                } else {
                  // When off clock: show single Clock In button
                  return ActionCircle(
                    icon: AppIcons.play,
                    label: "Clock In",
                    onComplete:
                        clockInController.attemptClockIn, // Press and hold
                    text: 'Press and hold to clock in',
                  );
                }
              }),
            ),
            // Obx(() {
            //   return InfoCard(
            //     message: clockInController.infoMessage.value,
            //     type: clockInController.infoType.value,
            //   );
            // }),
            Obx(() {
              return InfoCard(
                message: clockInController.infoMessage.value,
                type: clockInController.infoType.value,
                // onDismiss: () {
                //   clockInController.infoMessage.value = "";
                //   clockInController.infoType.value = InfoType.none;
                // },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CurrentTime extends StatefulWidget {
  @override
  State<_CurrentTime> createState() => _CurrentTimeState();
}

class _CurrentTimeState extends State<_CurrentTime> {
  String currentTime = "";

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      currentTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      currentTime,
      style: context.textTheme.bodyLarge
          ?.copyWith(fontSize: 40, color: const Color(0xff000000)),
    );
  }
}
