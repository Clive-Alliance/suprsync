import 'package:intl/intl.dart';

extension StringExt on String {

  String formatDate() {
    if(isEmpty) {
      return '';
    }

    final DateTime now = DateTime.now();
    final DateTime date = DateTime.parse(this);

    // Convert date to UTC
    final DateTime utcDate = date.toUtc();

    // Convert UTC date to GMT+1
    final DateTime gmtPlus1Date = utcDate.add(Duration(hours: 1));

    if (gmtPlus1Date.year == now.year &&
        gmtPlus1Date.month == now.month &&
        gmtPlus1Date.day == now.day) {
      // return 'Today, ${DateFormat.jm().format(gmtPlus1Date)}';
      return 'Today';
    } else if (gmtPlus1Date.year == now.year &&
        gmtPlus1Date.month == now.month &&
        gmtPlus1Date.day == now.day - 1) {
      // return 'Yesterday, ${DateFormat.jm().format(gmtPlus1Date)}';
      return 'Yesterday';
    } else {
      return DateFormat('d MMM y').format(gmtPlus1Date);
    }
  }

  String? formatIsoString({String format = 'MMMM d, y h:mma'}) {
    DateTime dateTime = DateTime.parse(this);
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }

  String capFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1).toLowerCase().replaceAll('_', ' ');
  }

  String getFirstLetters() {
    if (isEmpty){
      return '';
    }
    List<String> words = split(' ');

    // Initialize an empty string to store the result
    String result = '';

    // Iterate through each word
    for (int i = 0; i < 1; i++) {
      // If the word is not empty, add its first letter to the result
      if (words[i].isNotEmpty) {
        result += words[i][0];

        // If there is a next word, add its first letter to the result
        if (i + 1 < words.length && words[i + 1].isNotEmpty) {
          result += words[i + 1][0];
        }
      }
    }
    return result;
  }

  String maskStringExceptFirstTwo() {
    if (isEmpty) {
      return "";
    } else if (length <= 2) {
      return this; // No masking needed if 2 or fewer characters
    } else {
      // Get the first two characters
      final String visiblePart = substring(0, 2);
      // Calculate the number of characters to mask
      final int maskLength = length - 2;
      // Create the mask string (e.g., "***")
      final String maskedPart = '*' * maskLength;
      // Combine the visible and masked parts
      return visiblePart + maskedPart;
    }
  }


  String? formatDateString({String format = "yyyy/MM/dd HH.mm.ss" }) {
    try {
      final inputFormat = DateFormat("yyyy/MM/dd HH.mm.ss");
      final DateTime dateTime = inputFormat.parse(this);
      final outputFormat = DateFormat(format);
      return outputFormat.format(dateTime);
    } catch (e) {
      return null; // Return null or throw an error based on your error handling strategy
    }
  }

}