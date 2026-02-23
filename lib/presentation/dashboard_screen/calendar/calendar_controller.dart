import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suprsync/core/utils/alert_dialog.dart';
import 'package:suprsync/core/utils/date_utils.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/requested_timeoff_model.dart';
import 'package:suprsync/models/unavailable_days_model.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/controller/auth_controller.dart';
import 'package:suprsync/services/calendar_services.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../util/persistor/data_persistor.dart';

class CalendarController extends GetxController {
  // Reactive variables
  final CalendarServices _calendarServices = CalendarServices();
  final AuthController _authController = Get.find();
  final Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  final Rx<RangeSelectionMode> rangeSelectionMode =
      RangeSelectionMode.toggledOff.obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  final Rx<DateTime?> rangeStart = Rx<DateTime?>(null);
  final Rx<DateTime?> rangeEnd = Rx<DateTime?>(null);
  final RxSet<DateTime> eventDates = <DateTime>{}.obs; // Tracks selected dates
  final RxSet<DateTime> sentDates =
      <DateTime>{}.obs; // Tracks already sent dates
  var isLoading = false.obs;
  final Rx<String> reason = ''.obs;
  final Rx<String> startDate = ''.obs;
  final Rx<String> endDate = ''.obs;
  final Rx<String> todaysDate = ''.obs;
  RxList<RequestedTimeoffModel> requestedTimeoffs =
      <RequestedTimeoffModel>[].obs;

  Rx<bool> itemSelected = false.obs;
  Rx<bool> hasBeenAdded = false.obs;
  // Event list mapped by dates
  final RxMap<DateTime, List<String>> kEvents = <DateTime, List<String>>{}.obs;
  // List of dropdown items
  final List<String> items = [
    "Sick leave",
    "Unpaid time off",
    "Paid time off",
    "Emergency"
  ];

  // Observable for the selected item
  final selectedItem = RxnString();

  final String calendarDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // Method to handle item selection
  void selectItem(String value) {
    selectedItem.value = value;
    itemSelected(true);
  }

  void updateTodaysDate() {
    todaysDate.value = formatDate(calendarDate);
  }

  // Method to handle day selection
  void onDaySelected(DateTime selected, DateTime focused) {
    if (eventDates.contains(selected) && hasBeenAdded.value == true) {
      showAlertDialog(() async {
        unblockDate(selected);
      });
    } else if (eventDates.contains(selected) && hasBeenAdded.value == false) {
      eventDates.remove(selected);
      print('okayyyyyyy');
    } else {
      eventDates.add(selected);
      print(selected);
      kEvents[selected] = ["New Event"];
      // sendSelectedDatesToBackend(); // Handle sending dates
    }

    focusedDay.value = focused;
    selectedDay.value = selected;
  }

  // Method to handle range selection
  void onRangeSelected(DateTime? start, DateTime? end, DateTime focused) {
    rangeStart.value = start;
    rangeEnd.value = end;
    rangeSelectionMode.value = RangeSelectionMode.toggledOn;
    focusedDay.value = focused;
  }

  // Backend logic to send selected dates
  Future<void> sendSelectedDatesToBackend() async {
    final List<DateTime> newDates =
        eventDates.difference(sentDates).toList(); // Only send new dates

    if (newDates.isEmpty) {
      showSnackBar('No new dates to block.');
      return;
    }

    final List<String> formattedDates =
        newDates.map((date) => DateFormat('yyyy-MM-dd').format(date)).toList();
    showLoading();
    String token = await DataPersistor.getAccessToken();

    return await _calendarServices
        .blockDays(
      _authController.userAuth.value!.activeCompany!.memberships!.first.id
          .toString(),
      _authController
          .userAuth.value!.activeCompany!.memberships!.first.assignedBranchId
          .toString(),
      formattedDates,
      token.toString(),
    )
        .then((value) {
      hasBeenAdded(true);
      sentDates.addAll(newDates); // Mark these dates as sent
      Get.back();
      showSnackBar('Days blocked successfully');
    }).catchError((onError) {});
  }

  // Backend logic to unblock a date
  Future<void> unblockDate(DateTime date) async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    showLoading();
    String token = await DataPersistor.getAccessToken();

    return await _calendarServices
        .unblockDays(
      formattedDate,
      token.toString(),
    )
        .then((value) async {
      await fetchBlockedDates();
      hasBeenAdded(true);
      eventDates.remove(date); // Remove the date locally
      sentDates.remove(date); // Remove from sent dates as well
      kEvents.remove(date);
      focusedDay.value = focusedDay.value; // Trigger refresh
// Remove associated events
      Get.back();
      showSnackBar('Date made available successfully');
    }).catchError((onError) {
      Get.back();
      showSnackBar(onError.toString());
    });
  }

  Future fetchBlockedDates() async {
    String token = await DataPersistor.getAccessToken();

    _calendarServices
        .getBlockedDays(
            _authController.userId, token.toString())
        .then((check) {
      if (check is UnavailableDaysModel) {
        for (UnavailableDay day in check.unavailableDays ?? []) {
          if (day.blockedDays != null) {
            DateTime blockedDate = DateTime.utc(
              day.blockedDays!.year,
              day.blockedDays!.month,
              day.blockedDays!.day,
            );
            eventDates.add(blockedDate);
            sentDates.add(blockedDate); // Mark these as already sent
            kEvents[blockedDate] = [
              "Unavailable"
            ]; // Example for unavailable marker
          }
        }
      }
    }).catchError((error) {});
  }

  Future requestTimeOff() async {
    showLoading();
    String token = await DataPersistor.getAccessToken();

    return _calendarServices
        .requestUserTimeOff(reason.value, startDate.value, endDate.value,
            selectedItem.value, token.toString())
        .then((value) async {
      await fetchRequestedTimeOffs();
      Get.back();
      showSnackBar('time off requested successfully');
    }).catchError((error) {
      print('Error fetching blocked dates: $error');
    });
  }

  Future fetchRequestedTimeOffs() async {
    // showLoading();
    print(' i called this');
    String token = await DataPersistor.getAccessToken();

    return _calendarServices
        .getRequestedTimeOffs(token.toString())
        .then((value) {
      requestedTimeoffs.value = value;
      print(requestedTimeoffs.first);
      print("the value is not empty $value");
      // Get.back();
    }).catchError((error) {
      print('Error fetching blocked dates: $error');
    });
  }
}
