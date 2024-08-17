import 'package:flutter/material.dart';
import 'package:kiittime/components/constants.dart';
import 'package:kiittime/components/tt_builder.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});
  
  @override
  State<TimeTablePage> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTablePage> {
  List<String> tabs = Constants().daysIndex.keys.toList();
  int dayIndex = Constants().getDayIndex();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: dayIndex,
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('KIITIME'),
          bottom: TabBar(
            // isScrollable: true,
            tabs: [
              for (var day in tabs)
                Tab(
                  text: day.toUpperCase(),
                ),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 244, 236),
        body: TabBarView(
          children: [
            for (var day in tabs)
              TtBuilder(
                day: day.toUpperCase(),
              ),
          ],
        ),
      ),
    );
  }
}
