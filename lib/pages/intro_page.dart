import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kiittime/pages/home_page.dart';
import 'package:kiittime/pages/timetable_page.dart';

class IntroPage extends StatefulWidget {
  IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Box? ttBox = Hive.box(name: 'timetable');
  @override
  Widget build(BuildContext context) {
    if(ttBox == null || ttBox!.isEmpty){
      print('gone to homepage');
      return const HomePage();
    }
    else {
      return const TimeTablePage();
    }
  }
}