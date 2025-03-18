import 'package:intl/intl.dart';

String formatTimeRange(String startTime, String endTime) {
  // Define the input time format
  final inputFormat = DateFormat("HH:mm");

  // Parse the start and end times
  final startDateTime = inputFormat.parse(startTime);
  final endDateTime = inputFormat.parse(endTime);

  // Define the output format (e.g., 3:00 PM)
  final outputFormat = DateFormat("h:mm a");

  // Format the times
  final formattedStartTime = outputFormat.format(startDateTime);
  final formattedEndTime = outputFormat.format(endDateTime);

  // Combine the formatted times
  return "$formattedStartTime - $formattedEndTime";
}

String formatDate(String dateString) {
  // Parse the ISO date string
  DateTime dateTime = DateTime.parse(dateString);

  // Extract the day, month, and year
  int day = dateTime.day;
  String month = DateFormat('MMM').format(dateTime); // Abbreviated month
  String year = DateFormat('yyyy').format(dateTime); // Full year

  // Determine the ordinal suffix
  String suffix = getOrdinalSuffix(day);

  // Return the formatted date
  return '$day$suffix, $month, $year';
}

String getOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th'; // Special case for 11th, 12th, 13th
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

String calculateHours(String startTime, String endTime) {
  // Define the time format
  final timeFormat = DateFormat("HH:mm");

  // Parse the start and end times
  final startDateTime = timeFormat.parse(startTime);
  final endDateTime = timeFormat.parse(endTime);

  // Calculate the difference as a Duration
  final duration = endDateTime.difference(startDateTime);

  // If endTime is on the next day, adjust the duration
  final adjustedDuration =
      duration.isNegative ? Duration(hours: 24) + duration : duration;

  // Extract hours and minutes from the duration
  final hours = adjustedDuration.inHours;
  final minutes = adjustedDuration.inMinutes % 60;

  // Format the result as 08:00 hours
  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} hrs";
}

String formatDynamicDateRange() {
  // Get the current date
  final now = DateTime.now();

  // Get the first and last days of the current month
  final firstDayOfMonth = DateTime(now.year, now.month, 1);
  final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

  // Define a formatter for the month and day
  final monthFormatter = DateFormat("MMM");
  final dayFormatter = DateFormat("d");

  // Format the start and end dates
  String startDay =
      "${monthFormatter.format(firstDayOfMonth)} ${dayFormatter.format(firstDayOfMonth)}st";
  String endDay = "${dayFormatter.format(lastDayOfMonth)}th";

  return "$startDay - $endDay, ${now.year}";
}

///This formats the month to October, 30th, 2025
String monthFormatter(String dateTimeString) {
  // Parse the input string into a DateTime object
  final dateTime = DateTime.parse(dateTimeString);

  // Define the formatter for the month and year
  final formatter = DateFormat("MMMM d, yyyy");

  // Format the date without ordinal suffix
  String formattedDate = formatter.format(dateTime);

  // Extract the day part to add the ordinal suffix
  final day = dateTime.day;
  final suffix = (day == 1 || day == 21 || day == 31)
      ? "st"
      : (day == 2 || day == 22)
          ? "nd"
          : (day == 3 || day == 23)
              ? "rd"
              : "th";

  // Replace the day in the formatted string with the day + suffix
  formattedDate = formattedDate.replaceFirst(
    RegExp(r'\b\d{1,2}\b'), // Match only the day part
    "$day$suffix",
  );

  return formattedDate;
}
