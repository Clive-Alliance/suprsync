
import 'package:intl/intl.dart';

extension DateExt on DateTime {

  num daysToToday(){
    return DateTime.now().difference(this).inDays;
  }

  String formatDateNotifications() {
    final DateTime now = DateTime.now();

    // Convert date to UTC
    final DateTime utcDate = toUtc();

    // Convert UTC date to GMT+1
    final DateTime gmtPlus1Date = utcDate.add(Duration(hours: 1));

    if (gmtPlus1Date.year == now.year &&
        gmtPlus1Date.month == now.month &&
        gmtPlus1Date.day == now.day) {
      return 'Today';
    } else if (gmtPlus1Date.year == now.year &&
        gmtPlus1Date.month == now.month &&
        gmtPlus1Date.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM').format(gmtPlus1Date);
    }
  }

  String formatDateNotifications2() {
    final DateTime now = DateTime.now();

    // Assuming 'toUtc()' is a valid method or extension on DateTime
    final DateTime utcDate = toUtc();

    // Convert UTC date to GMT+1
    final DateTime gmtPlus1Date = utcDate.add(Duration(hours: 1));

    // Define a date format that includes hours, minutes, and seconds
    final DateFormat timeFormatWithSeconds = DateFormat('h:mm:ss a');

    if (gmtPlus1Date.year == now.year &&
        gmtPlus1Date.month == now.month &&
        gmtPlus1Date.day == now.day) {
      return 'Today, ${timeFormatWithSeconds.format(gmtPlus1Date)}';
    } else if (gmtPlus1Date.year == now.year &&
        gmtPlus1Date.month == now.month &&
        gmtPlus1Date.day == now.day - 1) {
      return 'Yesterday, ${timeFormatWithSeconds.format(gmtPlus1Date)}';
    } else {
      // For other dates, keep the original 'd MMM' format as requested implicitly
      // (the request for seconds was for 'Today' and 'Yesterday' cases)
      return DateFormat('d MMM yyyy, hh:mm a').format(gmtPlus1Date);
    }
  }


  String formatDateTime({String format = "EEEE, d MMMM, y h:mm a"}) {
    String formattedString = DateFormat(format).format(this);
    return formattedString;
  }

  bool hasAtLeast24HourDifference() {
    Duration difference = this.difference(DateTime.now());
    Duration absoluteDifference = difference.abs();
    const Duration twentyFourHours = Duration(hours: 24);
    return absoluteDifference >= twentyFourHours;
  }

}