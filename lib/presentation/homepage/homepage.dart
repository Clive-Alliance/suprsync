import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/models/signin_model.dart';
import 'package:suprsync/presentation/controllers/items_controller.dart';
import 'package:suprsync/presentation/homepage/account_information/account_information_page.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/homepage/calendar/calendar_controller.dart';
import 'package:suprsync/presentation/homepage/calendar/calendar_page.dart';
import 'package:suprsync/presentation/homepage/clockin_page/clockin_controller.dart';
import 'package:suprsync/presentation/homepage/clockin_page/clockin_page.dart';
import 'package:suprsync/presentation/homepage/inventory/inventory_screen.dart';
import 'package:suprsync/presentation/homepage/schedules/schedule_page.dart';
import 'package:suprsync/presentation/homepage/schedules/shedules_controller/available_shifts_controller.dart';
import 'package:suprsync/presentation/homepage/transfer/transfer_screen.dart';
import 'package:suprsync/presentation/homepage/withdrawal/withdrawal_controller/withdrawal_controller.dart';
import 'package:suprsync/presentation/homepage/withdrawal/withdrawal_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final CalendarController _calendarController = Get.find();
  final ClockInAndOutController _clockInAndOutController = Get.find();
  final ShiftController _shiftController = Get.find();
  final WithdrawalController _withdrawalController = Get.find();
  final ItemsController _itemsController = Get.find();
  SignInUserModel? userAuth;

  int tab = 0;
  @override
  void initState() {
    super.initState();
    _calendarController.fetchBlockedDates();
    _calendarController.fetchRequestedTimeOffs();
    _clockInAndOutController.getClockInSchedule();
    _shiftController.fetchAvailableShift();
    _withdrawalController.fetchAvailableLocatios();
    _itemsController.fetchAvailableLocatios();

    // authController.userAuth.value;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    // Only allow popping if we're on the first page
    if (_pageController.page == 0) {
      return true;
    } else {
      // Go back to the previous page instead of popping
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return false; // Prevent pop
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF00AD57),
        child: Image.asset(
          AppIcons.scanBarcode,
          height: 18,
          color: const Color(0xffffffff),
        ),
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              tab = index;
            });
          },
          children: const [
            // ClockInPage(),
            SchedulePage(
                // userAuth: widget.userAuth
                ),
            CalendarPage(
                // userAuth: widget.userAuth
                ),
            InventoryScreen(),

            AccountInformationPage(
                // userAuth: widget.userAuth
                ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: context.colorScheme.primaryContainer,
        height: 68,
        padding: const EdgeInsets.only(left: 35, right: 35, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // GestureDetector(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Image.asset(
            //         "assets/icons/clock.png",
            //         width: 17,
            //         color: tab == 0
            //             ? const Color(0xFF00AD57)
            //             : const Color(0xffA5A5A5),
            //       ),
            //       const SizedBox(height: 5),
            //       Text(
            //         "Clock In",
            //         style: style(tab, 0),
            //       ),
            //     ],
            //   ),
            //   onTap: () {
            //     setState(() {
            //       tab = 0;
            //     });
            //     _pageController.jumpToPage(0); // Change the page
            //   },
            // ),
            GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/schedule.png",
                    width: 17,
                    color: tab == 0
                        ? const Color(0xFF00AD57)
                        : const Color(0xffA5A5A5),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Schedule",
                    style: style(tab, 0),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  tab = 0;
                });
                _pageController.jumpToPage(0); // Change the page
              },
            ),
            GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppIcons.calendarOutline,
                    height: 18,
                    color: tab == 1
                        ? const Color(0xFF00AD57)
                        : const Color(0xffA5A5A5),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Calendar",
                    style: style(tab, 1),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  tab = 1;
                });
                _pageController.jumpToPage(1); // Change the page
              },
            ),
            GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppIcons.trade,
                    height: 18,
                    color: tab == 2
                        ? const Color(0xFF00AD57)
                        : const Color(0xffA5A5A5),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Inventory",
                    style: style(tab, 2),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  tab = 2;
                });
                _pageController.jumpToPage(2); // Change the page
              },
            ),
            GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/account_information .png",
                    width: 17,
                    color: tab == 3
                        ? const Color(0xFF00AD57)
                        : const Color(0xff7a7a7a),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Account",
                    style: style(tab, 3),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  tab = 3;
                });
                _pageController.jumpToPage(3); // Change the page
              },
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle style(int tab, int val) {
  return TextStyle(
      fontSize: 12,
      fontWeight: tab == val ? FontWeight.w600 : FontWeight.w500,
      color: tab == val ? const Color(0xFF000000) : const Color(0xff7A7A7A));
}
