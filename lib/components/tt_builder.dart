import 'package:flutter/material.dart';
import 'package:kiittime/components/class_tile.dart';
import 'package:kiittime/models/timetable_model.dart';
import 'package:provider/provider.dart';

class TtBuilder extends StatelessWidget {
  final String? day;
  const TtBuilder({
    this.day,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Center(
        child: Consumer<TimeTableModel>(
          builder: (context, model, child) {
            return FutureBuilder(
              future: model.getData(day!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final section = snapshot.data!;
                // print(section);
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: section.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
                  itemBuilder: ((context, index) {
                    final classroom = section[index];
                    return ClassTile(classroom: classroom);
                  }),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
