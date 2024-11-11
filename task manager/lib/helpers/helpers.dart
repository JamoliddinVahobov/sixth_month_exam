import 'package:intl/intl.dart';

class Helpers {
  static String formattedDateTime(DateTime dateTime) {
    return DateFormat('MMMM d, y h:mm a').format(dateTime);
  }
}
