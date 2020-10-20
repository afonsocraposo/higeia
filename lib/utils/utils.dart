import 'package:intl/intl.dart';

class Utils {
  static String formatDateTime(DateTime timestamp) {
    if (timestamp == null) {
      return "";
    } else {
      DateTime now = DateTime.now();
      timestamp = timestamp;

      if (now.difference(timestamp).inDays > 6) {
        if (now.year > timestamp.year) {
          return DateFormat("d/M/yyyy HH:mm").format(timestamp);
        } else {
          return DateFormat("d/M HH:mm").format(timestamp);
        }
      } else {
        if (now.difference(timestamp).inDays > 1) {
          return DateFormat("EEEEE").format(timestamp) +
              " at " +
              DateFormat("HH:mm").format(timestamp);
        } else {
          if (now.day != timestamp.day) {
            return "Yesterday at " + DateFormat.Hm().format(timestamp);
          } else {
            return DateFormat.Hm().format(timestamp);
          }
        }
      }
    }
  }
}
