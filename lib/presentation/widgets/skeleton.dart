import 'package:flutter/material.dart';
import 'package:kiittime/presentation/widgets/class_tile.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TimeTableSkeleton extends StatelessWidget {
  const TimeTableSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final dummy = {
      'Section': 'CSE-00',
      'Room': 'LH-XX',
      'Subject': 'SUBXX',
      'Time': 'X-X'
    };
    return Skeletonizer(
      containersColor: ShadTheme.of(context).colorScheme.muted,
      enabled: true, // Always enabled for the skeleton screen
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ClassTile(classroom: dummy);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 20,
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
