import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiittime/core/utils/days.dart';
import 'package:kiittime/presentation/pages/home_page.dart';
import 'package:kiittime/presentation/widgets/tt_builder.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  List<String> tabs = Constants().daysIndex.keys.toList();
  int day = Constants().getDayIndex();

  void reset() async {
    final ttBox = Hive.box('timetable');
    await ttBox.clear();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
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
    const url = 'https://kiittime.ashishpothal.tech/';
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
                  textScaler: TextScaler.noScaling,
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
      onPressed: () => showShadSheet(
        side: ShadSheetSide.bottom,
        context: context,
        builder: (context) => ShadSheet(
          title: const Text("Settings"),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: shareapp,
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: shadcon.colorScheme.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 3, color: shadcon.colorScheme.border),
                        ),
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
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: reset,
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: shadcon.colorScheme.destructive,
                          borderRadius: BorderRadius.circular(16),
                        ),
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
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Made with ❤️ by - ",
                    style: TextStyle(color: shadcon.colorScheme.foreground),
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
                height: 20,
              )
            ],
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
