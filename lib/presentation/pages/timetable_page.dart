import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiittime/core/utils/days.dart';
import 'package:kiittime/presentation/bloc/auth/auth_cubit.dart';
import 'package:kiittime/presentation/bloc/auth/auth_state.dart';
import 'package:kiittime/presentation/bloc/timetable/timetable_cubit.dart';
import 'package:kiittime/presentation/pages/home_page.dart';
import 'package:kiittime/presentation/widgets/tt_builder.dart';
// import 'package:kiittime/repo/noti_repo.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:timezone/timezone.dart' as tz;

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  List<String> tabs = Constants().daysIndex.keys.toList();
  int day = Constants().getDayIndex();
  final remindTimes = {
    10: 10,
    15: 15,
    20: 20,
    25: 25,
    30: 30,
  };
  int selectedReminderTime = 15;

  void saveReminderTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_offset', minutes);
    setState(() {
      selectedReminderTime = minutes;
    });
  }

  void reset() async {
    final ttBox = Hive.box('timetable');
    await ttBox.clear();
    if (context.mounted) {
      context.read<AuthCubit>().signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()),
          (Route<dynamic> route) => false);
    }
  }

  final Widget mainTitle = const Text(
    'KIITTIME',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: 4,
    ),
    textAlign: TextAlign.center,
  );

  void shareapp() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.ashish.kiittime&hl=en';
    await Share.share(
        '''Check Out KIIT TIME, A Clean TimeTable App, No-Fuzz : $url\n\nFor IOS users : https://kiittime.ashishpothal.tech''');
  }

  @override
  Widget build(BuildContext context) {
    var shadcon = ShadTheme.of(context);
    return DefaultTabController(
      initialIndex: day,
      length: 6,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: buildFab(shadcon, context),
          appBar: AppBar(
            titleSpacing: 20,
            title: mainTitle,
            centerTitle: true,
            // backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: shadcon.colorScheme.muted,
                ),
                child: TabBar(
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  unselectedLabelColor: shadcon.colorScheme.foreground,
                  dividerColor: Colors.transparent,
                  labelColor: shadcon.colorScheme.foreground,
                  splashBorderRadius: BorderRadius.circular(12),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  indicator: BoxDecoration(
                    color: shadcon.colorScheme.background,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    for (var day in tabs)
                      Tab(
                        height: 36,
                        text: day.toUpperCase(),
                      ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TabBarView(
              children: [
                for (var day in tabs)
                  TTBuilder(
                    day: day.toUpperCase(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton buildFab(ShadThemeData shadcon, BuildContext context) {
    return FloatingActionButton(
      backgroundColor: shadcon.colorScheme.background,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          color: ShadTheme.of(context).colorScheme.border,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: () => showShadDialog(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: ShadDialog(
            radius: BorderRadius.circular(16),
            removeBorderRadiusWhenTiny: false,
            constraints: const BoxConstraints(minWidth: 320),
            title: const Text("Settings"),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ShadButton.outline(
                            height: 56,
                            onPressed: shareapp,
                            child: Center(
                              child: Text(
                                "Share",
                                style: TextStyle(
                                    color: shadcon.colorScheme.foreground,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ShadButton.destructive(
                            height: 56,
                            onPressed: reset,
                            child: Center(
                              child: Text(
                                "Re-Enter Roll",
                                style: TextStyle(
                                    color: shadcon.colorScheme.foreground,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      return ShadSelect<int>(
                        shrinkWrap: true,
                        minWidth: constraints.maxWidth,
                        maxWidth: constraints.maxWidth,
                        // maxHeight: 200,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        placeholder: const Text('Time To Remind Before Class'),
                        optionsBuilder: (p0, index) {
                          final list = [10, 15, 20, 25, 30];
                          if (index >= list.length) return null;
                          return ShadOption(
                            value: list[index],
                            child: Text(list[index].toString()),
                          );
                        },
                        selectedOptionBuilder: (context, value) =>
                            Text(value.toString()),
                        onChanged: (value) async {
                          saveReminderTime(value ?? 15);
                          ShadToaster.of(context).show(
                            ShadToast(
                              alignment: Alignment.topCenter,
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.check_rounded,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Reminder Time Set",
                                  ),
                                ],
                              ),
                              description: Text(
                                  "We will remind you $value minutes before class."),
                            ),
                          );
                          context.read<TimetableCubit>().scheduleClasses();
                        },
                      );
                    }),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Text("Default : 15 mins"),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Made with ❤️ by - ",
                              style: TextStyle(
                                  color: shadcon.colorScheme.foreground),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final Uri url = Uri.parse(
                                    'https://www.linkedin.com/in/ashish-pothal/');
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              child: Text(
                                "Ashish Pothal",
                                style: TextStyle(
                                  color: shadcon.colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(
                                'mailto:ashishpothal@gmail.com?subject=Query%20Regarding%20KIIT%20Time');
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: Text(
                            "Need help? Click Here",
                            style: shadcon.textTheme.muted,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
      child: Icon(
        LucideIcons.settings,
        color: ShadTheme.of(context).colorScheme.foreground,
      ),
    );
  }
}
