import 'package:intl/intl.dart';

extension NumExt on num {

  num divideBy100() {
    return this / 100;
  }

  num multiplyBy100(){
    return this * 100;
  }

  String formatNumberWithCommas() {
    final formatter = NumberFormat('#,##0.####', 'en_US');
    return formatter.format(this);
  }

  String maskNumber() {
    String numberString = toString();
    int visibleCount = 3 + (numberString.length > 2 ? 2 : numberString.length);
    String maskedPart = 'x' * (numberString.length - visibleCount);
    String visiblePart = '${numberString.substring(0, 3)}$maskedPart${numberString.substring(numberString.length - 2)}';
    return visiblePart;
  }

  double roundTo({int places = 5}) {
    return double.parse(toStringAsFixed(places));
  }

  String getDigitsBeforeDecimal() {
    String numberString = formatNumberWithCommas().toString();
    if (numberString.contains('.')) {
      return numberString.split('.').first;
    } else {
      return numberString; // It's an integer or a string without a decimal
    }
  }

  String getDigitsAfterDecimal() {
    String numberString = toString();
    if (numberString.contains('.')) {
      return numberString.split('.').last;
    } else {
      return numberString;
    }
  }

}