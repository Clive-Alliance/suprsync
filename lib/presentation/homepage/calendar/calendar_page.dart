import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/date_utils.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/presentation/homepage/calendar/calendar_controller.dart';
import 'package:suprsync/presentation/homepage/calendar/requets_timeoff_page.dart';

import 'package:suprsync/presentation/homepage/schedules/widgets/eents_example.dart';
import 'package:suprsync/presentation/homepage/schedules/widgets/search_field.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = Get.find();
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;
  final date = DateTime.now();

  String get monthYear => DateFormat.yMMMM().format(DateTime.now());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    showLoading();
    _calendarController.fetchBlockedDates();
    _calendarController.fetchRequestedTimeOffs();
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SmartRefresher(
        onRefresh: _pullRefresh,
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onLoading: _onLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 44),
                  Row(
                    children: [
                      Text(
                        'Calendar',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff2C2C2C),
                        ),
                      ),
                      const Spacer(),
                      Obx(() {
                        bool isEventDates =
                            _calendarController.eventDates.isEmpty;
                        return GestureDetector(
                          onTap: () {
                            // showLoading();

                            if (isEventDates) {
                              showSnackBar('select a date to block');
                            } else {
                              _calendarController.sendSelectedDatesToBackend();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            height: 35,
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.add, size: 20),
                                Text(
                                  'Block Days',
                                  style: context.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set unavailable days and request time off here',
                    style: context.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 17),
                  const CustomSearchField(
                    hint: 'Search',
                    preficIcon: Icon(Icons.search),
                  ),
                  const SizedBox(height: 10),
                  TableEventsExample(),
                ],
              ),
            ),
            const SizedBox(height: 42.52),
            Container(
              height: 48,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                color: Color(0xff056033),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    'Time off',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff2C2C2C),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const RequestTimeOffScreen());
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xffE4FFF1),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: const Color(0xff00AD57),
                              width: 0.5,
                            ),
                          ),
                          child:
                              const Icon(Icons.add, color: Color(0xff056033)),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Request time off',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: const Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Obx(() {
              final requestedTimeoffs = _calendarController.requestedTimeoffs;
              return Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        requestedTimeoffs.isEmpty
                            ? SizedBox(
                                height: 200,
                                child: Center(
                                  child: Text('No requested time-off',
                                      style:
                                          context.textTheme.bodySmall?.copyWith(
                                        color: const Color(0xff000000),
                                      )),
                                ),
                              )
                            : Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: requestedTimeoffs.length,
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 20),
                                    itemBuilder: (context, index) {
                                      final String formattedStartDate =
                                          DateFormat('yyyy-MM-dd').format(
                                              _calendarController
                                                  .requestedTimeoffs[index]
                                                  .start!);
                                      final String formattedEndDate =
                                          DateFormat('yyyy-MM-dd').format(
                                              _calendarController
                                                  .requestedTimeoffs[index]
                                                  .end!);
                                      String startDate =
                                          formatDate(formattedStartDate);
                                      String endDate =
                                          formatDate(formattedEndDate);

                                      // String starteDate =
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: const Color(0xffF9F8F8),
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      AppIcons.calendarOutline,
                                                      height: 18,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      'Requested time-off',
                                                      style: context
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                        color: const Color(
                                                            0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xffEAEAEA),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '${startDate} - ${endDate}',
                                                    style: context
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      color: const Color(
                                                          0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Color(_calendarController
                                                            .requestedTimeoffs[
                                                                index]
                                                            .status
                                                            .toString() ==
                                                        'approved'
                                                    ? 0xff056033
                                                    : 0xffD9694D),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6),
                                                child: Text(
                                                  _calendarController
                                                      .requestedTimeoffs[index]
                                                      .status
                                                      .toString()
                                                      .capitalizeFirst!,
                                                  style: context
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                    color:
                                                        const Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                      ],
                    )),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
