import 'package:intl/intl.dart';

DateTime parseCustomDate(String dateString) {
  final format = DateFormat("dd-MM-yyyy'T'HH:mm:ss:SSS");
  try {
    return format.parse(dateString);
  } catch (e) {
    throw FormatException("Error parsing custom date format: $dateString", e);
  }
}
