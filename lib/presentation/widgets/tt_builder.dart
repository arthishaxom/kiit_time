import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiittime/presentation/bloc/timetable/timetable_cubit.dart';
import 'package:kiittime/presentation/widgets/class_tile.dart';
import 'package:kiittime/presentation/widgets/skeleton.dart';

class TTBuilder extends StatelessWidget {
  final String day;

  const TTBuilder({
    required this.day,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimetableCubit, TimetableState>(
      builder: (context, state) {
        if (state is TimetableLoaded) {
          final ttBox = Hive.box('timetable');
          final section = ttBox.get(day);
          return ListView.separated(
            shrinkWrap: true,
            itemCount: section.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 12,
            ),
            itemBuilder: (context, index) {
              final classroom = Map<String, dynamic>.from(section[index]);
              return ClassTile(classroom: classroom);
            },
          );
        } else if (state is TimetableLoading) {
          return const TimeTableSkeleton();
        } else {
          // if (state is TimetableError) {
          //   print(state.message);
          // }
          return const Center(child: Text('No timetable available.'));
        }
      },
    );
  }
}
