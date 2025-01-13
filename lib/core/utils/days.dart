import 'package:intl/intl.dart';

class Constants {
  final Map<String, int> daysIndex = {
    'Mon': 0,
    'Tue': 1,
    'Wed': 2,
    'Thu': 3,
    'Fri': 4,
    'Sat': 5
  };

  String getDayIndex() {
    String day = DateFormat('E').format(DateTime.now());
    if (day == 'Sun') {
      return 'Mon';
    } else {
      return day;
    }
  }
}
