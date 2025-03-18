import 'package:intl/intl.dart';

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
  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} hours";
}
