import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kiittime/components/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeTableModel with ChangeNotifier {
  final supabase = Supabase.instance.client;
  final ttBox = Hive.box(name: 'timetable');

  Future<void> getData() async {
    List<String> tabs = Constants().daysIndex.keys.toList();
    for (var day in tabs) {
      final data = await supabase
          .from('year3_tt')
          .select()
          .inFilter('Section', [
            ttBox.get('section')!,
            ttBox.get('elective1')!,
            ttBox.get('elective2')!
          ])
          .eq('Day', day.toUpperCase())
          .order('Time_Sort', ascending: true);
      ttBox.put(day.toUpperCase(), data);
    }
    notifyListeners();
  }

  Future<void> getSection(String roll) async {
    final data =
        await supabase.from('year3_sections').select().eq('Roll', roll);
    ttBox.putAll({
      'section': data[0]['Section'],
      'elective1': data[1]['Section'],
      'elective2': data[2]['Section']
    });
    notifyListeners();
  }
}

                  