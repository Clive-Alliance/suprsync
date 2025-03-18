import 'package:intl/intl.dart';

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
