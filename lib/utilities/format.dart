import 'package:intl/intl.dart';

class FormatDate {
  static String dmy(String dateSB) {
    List<String> listDate;
    String newDate;
    listDate = dateSB.split('T');
    listDate = listDate.first.split('-');
    newDate =
        '${listDate.elementAt(2)}/${listDate.elementAt(1)}/${listDate.elementAt(0)}';
    return newDate;
  }
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
}
