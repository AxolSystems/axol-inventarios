import 'package:intl/intl.dart';

class FormatDate {
  static String dmy(DateTime dateTime) {
    String dateText;
    dateText = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return dateText;
  }

  static String dmyHm(DateTime dateTime) {
    String dateText;
    dateText =
        '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    return dateText;
  }

  static String ddMonthYear(DateTime dateTime) {
    String dateText;
    Map<int, String> month = {
      0: '',
      1: 'enero',
      2: 'febrero',
      3: 'marzo',
      4: 'abril',
      5: 'mayo',
      6: 'junio',
      7: 'julio',
      8: 'agosto',
      9: 'septiembre',
      10: 'octubre',
      11: 'noviembre',
      12: 'diciembre',
    };
    dateText = '${dateTime.day} de ${month[dateTime.month]}, ${dateTime.year}';
    return dateText;
  }

  static String ddMonthYearTest(DateTime dateTime) {
    String dateText;
    Map<int, String> month = {
      0: '',
      1: 'enero',
      2: 'febrero',
      3: 'marzo',
      4: 'abril',
      5: 'mayo',
      6: 'junio',
      7: 'julio',
      8: 'agosto',
      9: 'septiembre',
      10: 'octubre',
      11: 'noviembre',
      12: 'diciembre',
    };
    dateText = '${dateTime.day} de ${month[dateTime.month]} de ${dateTime.year}';
    return dateText;
  }

  static DateTime startDay(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);

  static DateTime endDay(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);
}

class FormatNumber {
  static String decimal(double number) {
    List<String> partList;
    String newNumber;
    RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');
    partList = number.toString().split('.');
    partList[0] = partList[0].replaceAll(re, ',');
    if (partList.length > 1) {
      newNumber = '${partList[0]}.${partList[1]}';
    } else {
      newNumber = partList[0];
    }
    return newNumber;
  }

  static String format2dec(double number) {
    String finalNumber;
    finalNumber = NumberFormat('#,##0.00', 'en_US').format(number);
    return finalNumber;
  }

  static String format2dig(int number) {
    final String textNum;
    if (number < 10) {
      textNum = number.toString().padLeft(2, '0');
    } else {
      textNum = number.toString();
    }
    return textNum;
  }
}
