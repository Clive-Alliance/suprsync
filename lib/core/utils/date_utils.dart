import 'package:intl/intl.dart';

String formatTimeRange(String startTime, String endTime) {
  // Define the input time format
  final inputFormat = DateFormat("HH:mm");

  // Parse the start and end times
  final startDateTime = inputFormat.parse(startTime);
  final endDateTime = inputFormat.parse(endTime);

  final outputFormat = DateFormat("h:mm a");

  final formattedStartTime = outputFormat.format(startDateTime);
  final formattedEndTime = outputFormat.format(endDateTime);

  return "$formattedStartTime - $formattedEndTime";
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  int day = dateTime.day;
  String month = DateFormat('MMM').format(dateTime);
  String year = DateFormat('yyyy').format(dateTime);

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

class TimeUtils {
  static String formatTo12Hour(String time24) {
    if (time24.isEmpty) return '';

    try {
      // Parse the time (assuming format like "8:00" or "16:00")
      final parts = time24.split(':');
      if (parts.length != 2) return time24; // Return original if invalid format

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      String period = hour >= 12 ? 'PM' : 'AM';

      // Convert 24-hour to 12-hour
      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour = hour - 12;
      }

      String minuteStr = minute.toString().padLeft(2, '0');

      return '$hour:$minuteStr $period';
    } catch (e) {
      return time24;
    }
  }

  static String getShiftStartText(DateTime start) {
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

  static String formatTimeRange(String startTime, String endTime) {
    final start = formatTo12Hour(startTime);
    final end = formatTo12Hour(endTime);
    return '$start - $end';
  }

  static String calculateHours(String startTime, String endTime) {
    try {
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');

      if (startParts.length != 2 || endParts.length != 2) {
        return "Invalid time";
      }

      final startHour = int.parse(startParts[0]);
      final startMinute = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMinute = int.parse(endParts[1]);

      final startTotalMinutes = startHour * 60 + startMinute;
      final endTotalMinutes = endHour * 60 + endMinute;

      int durationMinutes = endTotalMinutes - startTotalMinutes;

      if (durationMinutes < 0) {
        durationMinutes += 24 * 60;
      }

      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;

      if (minutes == 0) {
        return "$hours hour${hours != 1 ? 's' : ''}";
      } else {
        return "$hours hour${hours != 1 ? 's' : ''} ${minutes} minute${minutes != 1 ? 's' : ''}";
      }
    } catch (e) {
      return "Invalid time";
    }
  }

  static DateTime? parseDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return null;

    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }
}
