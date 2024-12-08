import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiittime/pages/roll_page.dart';
import 'package:kiittime/pages/timetable_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Box ttBox = Hive.box('timetable');

  @override
  Widget build(BuildContext context) {
    if (ttBox.get('roll') == null || ttBox.isEmpty) {
      return const RollPage();
    } else {
      String roll = ttBox.get('roll');
      return TimeTablePage(
        rollNumber: roll,
      );
    }
  }
}
