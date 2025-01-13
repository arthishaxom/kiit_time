import 'package:hive_ce/hive.dart';
import 'package:kiittime/core/utils/days.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimetableRepository {
  final SupabaseClient supabase;
  final Box timetableBox;

  TimetableRepository({required this.supabase, required this.timetableBox});

  Future<void> fetchAndStoreTimetable(String roll) async {
    List<String> days = Constants().daysIndex.keys.toList();

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

    // Fetch section data from Supabase
    final sectionData = await supabase
        .from('year${collegeYear}_sections')
        .select()
        .eq('Roll', roll);

    // Prepare a map to store section information
    Map<String, dynamic> sectionMap = {'roll': roll};
    for (var i = 0; i < sectionData.length; i++) {
      sectionMap['section${i + 1}'] = sectionData[i]['Section'];
    }
    // Store section information in Hive
    await timetableBox.putAll(sectionMap);

    // Fetch and store timetable data for each day
    for (var day in days) {
      final data = await supabase
          .from(tableName)
          .select()
          .inFilter('Section', sectionMap.values.toList())
          .eq('Day', day.toUpperCase())
          .order('Time_Sort', ascending: true);
      await timetableBox.put(day.toUpperCase(), data);
    }
  }
}
