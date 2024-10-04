import 'package:intl/intl.dart';

dateFormat(date){
  String originalDate = date;
  DateTime parsedDate = DateTime.parse(originalDate);
  String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
  print(formattedDate); // Output: 18/01/2015
  return formattedDate;
}