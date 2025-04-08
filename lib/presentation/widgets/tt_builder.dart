import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiittime/presentation/bloc/timetable/timetable_cubit.dart';
import 'package:kiittime/presentation/widgets/class_tile.dart';
import 'package:kiittime/presentation/widgets/skeleton.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class TTBuilder extends StatelessWidget {
  final String day;

  const TTBuilder({
    required this.day,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var shadcon = ShadTheme.of(context);
    return BlocBuilder<TimetableCubit, TimetableState>(
      builder: (context, state) {
        if (state is TimetableLoaded) {
          final ttBox = Hive.box('timetable');
          final section = ttBox.get(day);

          if (section.length < 1) {
            return Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "No Classes Today\n",
                    style: shadcon.textTheme.h3.copyWith(
                      letterSpacing: 2,
                    ),
                    children: [
                      TextSpan(
                          text: "Have Fun 😁",
                          style: shadcon.textTheme.h3.copyWith(
                            letterSpacing: 2,
                            color: shadcon.colorScheme.primary,
                          ))
                    ]),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
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
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: TimeTableSkeleton(),
          );
        } else {
          if (state is TimetableError) {
            return Center(
              child: Text(state.message),
            );
          }
          return Center(
            child: GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(
                    'mailto:pothal.builds@gmail.com?subject=Query%20Regarding%20KIIT%20Time');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  softWrap: true,
                  text: TextSpan(
                      text:
                          "It looks like either your roll no. doesn't exists or we don't have your Timetable. If you believe your roll no. is correct, you can share your timetable with me by mailing it to - \n",
                      style: shadcon.textTheme.small.copyWith(height: 1.5),
                      children: <TextSpan>[
                        TextSpan(
                          text: "pothal.builds@gmail.com",
                          style: ShadTheme.of(context).textTheme.p.copyWith(
                                color: shadcon.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      ]),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
