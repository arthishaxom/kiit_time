import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiittime/presentation/bloc/timetable/timetable_cubit.dart';
import 'package:kiittime/presentation/pages/timetable_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController rollController = TextEditingController();
  String _errorText = 'Default';
  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorText = 'Enter Valid Roll Number';
      } else if (value.length < 7) {
        _errorText = 'Roll Number must be atleast 7 digits long';
      } else {
        _errorText = "Default"; // Input is valid
      }
    });
  }

  Box ttBox = Hive.box('timetable');

  @override
  Widget build(BuildContext context) {
    final shadcon = ShadTheme.of(context);
    if (ttBox.get('roll') == null || ttBox.isEmpty) {
      return _buildHomePage(shadcon, context);
    } else {
      context.read<TimetableCubit>().loadLocalTimetable();
      return const TimetablePage();
    }
  }

  Scaffold _buildHomePage(ShadThemeData shadcon, BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/core/assets/BG.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 32,
            ),
            Image.asset(
              'lib/core/assets/kiittime_fg.png',
              scale: .2,
              width: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShadCard(
                title: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'lib/core/assets/kiittime_logo.png',
                      width: 80,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        "Roll Number",
                        style: shadcon.textTheme.h4,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ShadInput(
                      controller: rollController,
                      onPressedOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.number,
                      placeholder: const Text("0000000"),
                      placeholderStyle: shadcon.textTheme.lead.copyWith(
                        fontFamily: shadcon.textTheme.family,
                        fontSize: 32,
                      ),
                      style: shadcon.textTheme.h3.copyWith(
                        fontFamily: shadcon.textTheme.family,
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLength: 8,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ShadButton(
                      onPressed: () {
                        _validateInput(rollController.text);
                        if (_errorText == "Default") {
                          context
                              .read<TimetableCubit>()
                              .loadTimetable(rollController.text);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const TimetablePage(),
                            ),
                          );
                        } else {
                          ShadToaster.of(context).show(
                            ShadToast(
                              alignment: Alignment.topCenter,
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    color: shadcon.colorScheme.foreground,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    _errorText,
                                    style: TextStyle(
                                        color: shadcon.colorScheme.foreground),
                                  ),
                                ],
                              ),
                              backgroundColor: shadcon.colorScheme.destructive,
                            ),
                          );
                        }
                      },
                      width: double.infinity,
                      height: 56,
                      child: Text(
                        "Submit",
                        style: shadcon.textTheme.h4,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
