import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kiittime/components/constants.dart';
import 'package:kiittime/components/skeleton_table.dart';
import 'package:kiittime/components/tt_builder.dart';
import 'package:kiittime/models/theme_provider.dart';
import 'package:kiittime/models/timetable_model.dart';
import 'package:kiittime/pages/roll_notfound.dart';
import 'package:kiittime/pages/roll_page.dart';
import 'package:kiittime/theme/extensions.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TimeTablePage extends StatefulWidget {
  final String rollNumber;

  const TimeTablePage({super.key, required this.rollNumber});

  @override
  State<TimeTablePage> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTablePage> {
  List<String> tabs = Constants().daysIndex.keys.toList();
  int dayIndex = Constants().getDayIndex();

  Future<void> _fetchTimeTableData(BuildContext context) async {
    Box ttBox = Hive.box(name: 'timetable');
    if (ttBox.isEmpty) {
      await context
          .read<TimeTableModel>()
          .getData(widget.rollNumber); // Assuming you pass the roll number
    }
  }

  void reset() {
    final ttBox = Hive.box(name: 'timetable');
    ttBox.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const RollPage(),
        settings: const RouteSettings(name: '/roll'),
      ),
      (Route<dynamic> route) => false,
    );
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
    const url = 'https://github.com/arthishaxom/kiit_time/releases';
    await Share.share(
        'Check Out This Timetable App : $url. You can download it from github, just download the apk file and install.');
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return FutureBuilder(
      future: _fetchTimeTableData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: mainTitle,
              centerTitle: true,
              titleSpacing: 20,
              backgroundColor: Colors.transparent,
            ),
            body: const TimeTableSkeleton(), // Show skeleton while loading
          );
        } else if (snapshot.hasError) {
          return const RollNotfound();
        } else {
          return DefaultTabController(
            initialIndex: dayIndex,
            length: 6,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.settings,
                  color: context.colorScheme.onSurface,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return AnimatedContainer(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: context.colorScheme.tertiaryContainer,
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.dark_mode_rounded,
                                            color:
                                                context.colorScheme.onSurface,
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            "Dark Mode",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: context
                                                    .colorScheme.onSurface),
                                          )
                                        ],
                                      ),
                                      Transform.scale(
                                        scale: 0.8,
                                        alignment: Alignment.centerRight,
                                        child: Switch(
                                          value: themeProvider.isDarkMode,
                                          onChanged: (value) {
                                            setState(() {
                                              themeProvider.toggleTheme();
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: shareapp,
                                        child: Container(
                                          height: 60,
                                          margin: const EdgeInsets.only(
                                              left: 32, right: 8, top: 12),
                                          decoration: BoxDecoration(
                                              color: context
                                                  .colorScheme.surfaceContainer,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Center(
                                            child: Text(
                                              "Share",
                                              style: TextStyle(
                                                  color: context.colorScheme
                                                      .onInverseSurface,
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
                                          margin: const EdgeInsets.only(
                                              left: 8, right: 32, top: 12),
                                          decoration: BoxDecoration(
                                              color: context
                                                  .colorScheme.errorContainer,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Center(
                                            child: Text(
                                              "Re-Enter Roll",
                                              style: TextStyle(
                                                  color: context.colorScheme
                                                      .onErrorContainer,
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
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              appBar: AppBar(
                titleSpacing: 20,
                title: mainTitle,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                bottom: TabBar(
                  unselectedLabelColor: context.colorScheme.tertiary,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  dividerColor: Colors.transparent,
                  labelColor: context.colorScheme.primary,
                  splashBorderRadius: BorderRadius.circular(12),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    for (var day in tabs)
                      Tab(
                        height: 36,
                        text: day.toUpperCase(),
                      ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  for (var day in tabs)
                    TTBuilder(
                      day: day.toUpperCase(),
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
