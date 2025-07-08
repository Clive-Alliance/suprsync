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
import 'package:suprsync/presentation/dashboard_screen/calendar/calendar_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/schedules/shedules_controller/available_shifts_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/widgets/swap_cards.dart';
import 'package:suprsync/presentation/face_detection_screen.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/clockin_page/clockin_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/clockin_page/widgets/checkin_list_tile.dart';
import 'package:suprsync/presentation/dashboard_screen/clockin_page/widgets/clockout_bottom_sheet.dart';
import 'package:suprsync/presentation/dashboard_screen/withdrawal/withdrawal_screen.dart';

class ClockInPage extends StatefulWidget {
  const ClockInPage({super.key, this.id});
  final String? id;
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
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;

  String get monthYear => DateFormat.yMMMM().format(DateTime.now());
  final ShiftController _shiftController = Get.find();
  final CalendarController _calendarController = Get.find();
  final AuthController _authController = Get.find();

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
            '${authController.firstName.value} ${authController.lastName.value.substring(0, 1)}.',
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
              Get.to(() => AccountInformationPage(
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

                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    // height: 200, // or any appropriate size
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppIcons.shiftsCard),
                        // scale: 0.5,
                        fit: BoxFit.fill, // or contain, fill, etc.
                      ),
                      // color: Colors.yellow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xffF5F5F5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.access_time, color: Colors.green),
                              SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('Starts in 2 min',
                              style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff414141),
                                  fontSize: 18)),
                          Text(
                            '12:00PM-8:30PM at Guava',
                            style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff414141),
                                fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   '12:00 PM - 8:30 PM at Guava',
                          //   style: GoogleFonts.poppins(color: Colors.grey.shade600),
                          // ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 150,
                            child: RectangularButton(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Requests & Inventory Row
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
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff414141)),
                            ),
                            const SizedBox(height: 40),
                            TransparentRectangularButton(
                              onPress: () {
                                Get.back();
                                // Add your login logic here
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

                // ShiftCard(
                //     isActive: isActive,
                //     time: time,
                //     day: day,
                //     id: id,
                //     title: title,
                //     branch: branch,
                //     hexcode: hexcode,
                //     initials: initials)
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildShiftCard(
      String date, String duration, String company, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
              ],
            ),
          )
        ],
      ),
    );
  }
}


// class ShiftCard extends StatelessWidget {
//   const ShiftCard({
//     super.key,
//     // required this.isActive,
//     // required this.time,
//     // required this.day,
//     // required this.id,
//     // this.isOpenForSwap = false,
//     // required this.title,
//     // required this.branch,
//     // required this.hexcode,
//     // required this.initials
//   });
//   // final String title;
//   // final bool isActive;
//   // final String id;
//   // final String time;
//   // final String day;
//   // final bool isOpenForSwap;
//   // final String branch;
//   // final String hexcode;
//   // final String initials;
//   @override
//   Widget build(BuildContext context) {
//     final ClockInAndOutController _clockInController = Get.find();
//     final AuthController _authController = Get.find();

//     return Card(
//       color: const Color(0xffFBFBFB),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0),
//           side: const BorderSide(color: Color(0xffF5F5F5))),
//       margin: const EdgeInsets.only(
//         left: 20,
//         right: 20,
//         top: 19,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
//         child: IntrinsicHeight(
//           child: Row(
//             children: [
//               const ClipRRect(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(50),
//                     bottomLeft: Radius.circular(50)),
//                 child: VerticalDivider(
//                   color: Colors.black,
//                   width: 5,
//                   thickness: 8,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 14.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       time.removeAllWhitespace,
//                       style: context.textTheme.labelMedium
//                           ?.copyWith(color: const Color(0xE59A9A9A)),
//                     ),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       day,
//                       style: context.textTheme.labelMedium?.copyWith(
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xff8E8E90)),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // NetworkImage(_authController.userDp.value),
//                         _authController.userAuth.value!.user!.picture != null
//                             ? CircleAvatar(
//                                 foregroundImage: NetworkImage(_authController
//                                     .userAuth.value!.user!.picture!.url
//                                     .toString()),
//                                 // backgroundColor: Color(hexcode)
//                               )
//                             : CircleAvatar(
//                                 radius: 18,
//                                 backgroundColor: const Color(0xff00AD57),
//                                 child: Text(
//                                   initials.removeAllWhitespace,
//                                   style: context.textTheme.bodySmall?.copyWith(
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                         const SizedBox(
//                           width: 5.0,
//                         ),
//                         Text(
//                           title,
//                           style: context.textTheme.bodyMedium
//                               ?.copyWith(fontWeight: FontWeight.w600),
//                         ),
//                         // Expanded(child: SizedBox()),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       children: [
//                         Image.asset('assets/icons/Map Point Wave.png',
//                             width: 17,
//                             color: Color(
//                               int.parse(hexcode),
//                             )),
//                         const SizedBox(
//                           width: 4,
//                         ),
//                         Text(
//                           branch,
//                           style: context.textTheme.labelSmall
//                               ?.copyWith(color: Color(int.parse(hexcode))),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Obx(() {
//                     _clockInController.shiftId.value;
//                     return IconButton(
//                       icon: const Icon(Icons.more_vert),
//                       onPressed: () {
//                         // _showSwapShiftDialog(context);
//                         _clockInController.shiftId.value = id;
//                         print(
//                             'show pop up 2${_clockInController.shiftId.value}');
//                       },
//                     );
//                   }),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void showWithdrawalSheet(BuildContext context) {
//     TextEditingController _emailController = TextEditingController();
//     TextEditingController _passwordController = TextEditingController();
//     // AuthController _authController = AuthController();
//     bool isVisible = false;
//     Size size = MediaQuery.of(context).size;
//     showModalBottomSheet(
//         isScrollControlled: true,
//         backgroundColor: context.colorScheme.secondary,
//         context: context,
//         builder: (BuildContext context) {
//           return WithdrawalSheetSheet(
//               // emailController: _emailController,
//               // // isVisible: isVisible,
//               // passwordController: _passwordController,
//               // authController: _authController
//               );
//         });
//   }
// }
