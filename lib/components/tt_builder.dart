import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kiittime/components/class_tile.dart';

class TTBuilder extends StatelessWidget {
  final String? day;
  TTBuilder({
    this.day,
    super.key,
  });
  final ttBox = Hive.box(name: 'timetable');

  @override
  Widget build(BuildContext context) {
    final section = ttBox.get(day!);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Center(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: section.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 12,
          ),
          itemBuilder: ((context, index) {
            final classroom = section[index];
            return ClassTile(classroom: classroom);
          }),
        ),
      ),
    );
  }
}
