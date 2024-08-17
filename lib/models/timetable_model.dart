import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeTableModel with ChangeNotifier {
  Object? section='';
  Object? elective1='';
  Object? elective2='';
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getData(String day) async {
    final data = supabase
        .from('year3_tt')
        .select()
        .inFilter('Section', [section!,elective1!,elective2!])
        .eq('Day', day).order('Time_Sort',ascending: true);
    return data;
  }

  void getSection(String roll) async{
    final data = await supabase.from('year3_sections').select().eq('Roll', roll);
    section = data[0]['Section'];
    elective1 = data[1]['Section'];
    elective2 = data[2]['Section'];
    notifyListeners();
  }
}
