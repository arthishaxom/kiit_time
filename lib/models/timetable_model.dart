import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiittime/components/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeTableModel with ChangeNotifier {
  final supabase = Supabase.instance.client;
  final ttBox = Hive.box('timetable');

  Future<void> getData(String roll) async {
    List<String> tabs = Constants().daysIndex.keys.toList();

    // Calculate the year of admission and current year
    int admissionYear = int.parse(roll.substring(0, 2));
    int currentYear = DateTime.now().year % 100;
    int collegeYear = currentYear - admissionYear + 1;
    if (DateTime.now().month < 7) {
      collegeYear -= 1;
    }

    // Check if the 5th digit is 7 (lateral entry student)
    if (roll.length > 4 && roll[4] == '7') {
      collegeYear += 1;
    }

    // Determine the table name based on the college year
    String tableName = 'year${collegeYear}_tt';

    final sectionData = await supabase
        .from('year${collegeYear}_sections')
        .select()
        .eq('Roll', roll);
    Map<String, dynamic> sectionMap = {'roll': roll};

    for (var i = 0; i < sectionData.length; i++) {
      sectionMap['section${i + 1}'] = sectionData[i]['Section'];
    }

    ttBox.putAll(sectionMap);

    for (var day in tabs) {
      final data = await supabase
          .from(tableName)
          .select()
          .inFilter('Section', sectionMap.values.toList())
          .eq('Day', day.toUpperCase())
          .order('Time_Sort', ascending: true);
      ttBox.put(day.toUpperCase(), data);
    }
    notifyListeners();
  }
}
