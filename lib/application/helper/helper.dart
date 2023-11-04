import 'package:intl/intl.dart';

String tzToDateTime(String dt){

  DateFormat dateFormat = DateFormat('yyyy/MM/dd - hh:mm a');
  
  return dateFormat.format(DateTime.parse(dt).toLocal());
}