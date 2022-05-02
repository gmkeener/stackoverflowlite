import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// ignore_for_file: file_names

class DateHelper {
  static final intToDays = {
    0: 'Domingo',
    1: 'Segunda',
    2: 'Terça',
    3: 'Quarta',
    4: 'Quinta',
    5: 'Sexta',
    6: 'Sábado'
  };

  static String formatFromTimestamp(Timestamp timestamp) {
    var date = DateTime.parse(timestamp.toDate().toString());
    return formatDateToDayMonthYear(date);
  }

  static String formatFromDateString(String dateString) {
    var date = DateTime.parse(dateString);
    return formatDateToDayMonthYear(date);
  }

  static String formatDateToCalendarModal(DateTime date) {
    String finalDate = "";
    var timeArr = date.toString().split(" ");
    var data = timeArr[0].split('-').getRange(1, 3).toList();
    var hora = timeArr[1].split(':');
    finalDate = (intToDays[date.weekday] as String) +
        ' ${data[1]}/${data[0]} - ${hora[0]} hrs${hora[1] == '00' ? '' : ' ${hora[1]} mns'}';
    return finalDate;
  }

  static String formatDateToDayMonthYear(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  static String formatDateFullBy(DateTime date) {
    Map<int, String> intToMonth = {
      1: 'janeiro',
      2: 'fevereiro',
      3: 'março',
      4: 'abril',
      5: 'maio',
      6: 'junho',
      7: 'julho',
      8: 'agosto',
      9: 'setembro',
      10: 'outubro',
      11: 'novembro',
      12: 'dezembro',
    };
    List<String> dmy = formatDateToDayMonthYear(date).split('/');
    dmy[1] = intToMonth[date.month] as String;
    return dmy.join(' de ');
  }
}
