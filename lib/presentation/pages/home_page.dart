import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:kiittime/presentation/bloc/timetable/timetable_cubit.dart';
import 'package:kiittime/presentation/pages/timetable_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';

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
        _errorText = 'Roll Number must be at least 7 digits long';
      } else {
        _errorText = "Default"; // Input is valid
      }
    });
  }

  Box ttBox = Hive.box('timetable');

  @override
  Widget build(BuildContext context) {
    var shadcon = ShadTheme.of(context);
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            var emailSplit = (state.userMail).split("@");
            if (emailSplit[1] == "kiit.ac.in") {
              context.read<TimetableCubit>().loadTimetable(emailSplit[0]);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TimetablePage()),
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
                      const SizedBox(width: 8),
                      Text(
                        "Kindly SignIn With Your KIIT Mail.",
                        style: TextStyle(color: shadcon.colorScheme.foreground),
                      ),
                    ],
                  ),
                  backgroundColor: shadcon.colorScheme.destructive,
                ),
              );
              context.read<AuthCubit>().signOut();
            }
          } else if (state is AuthError) {
            ShadToaster.of(context).show(
              ShadToast(
                alignment: Alignment.topCenter,
                title: Row(
                  children: [
                    Icon(
                      Icons.login_rounded,
                      color: shadcon.colorScheme.foreground,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Error",
                      style: TextStyle(color: shadcon.colorScheme.foreground),
                    ),
                  ],
                ),
                description: Text(state.message),
                backgroundColor: shadcon.colorScheme.destructive,
              ),
            );
          } else if (state is AuthLoading) {
            ShadToaster.of(context).show(
              ShadToast(
                alignment: Alignment.topCenter,
                title: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: shadcon.colorScheme.foreground,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Logging In",
                      style: TextStyle(color: shadcon.colorScheme.foreground),
                    ),
                  ],
                ),
                backgroundColor: shadcon.colorScheme.accent,
              ),
            );
          }
        },
        builder: (context, state) {
          if (ttBox.get('roll') != null) {
            context.read<TimetableCubit>().loadLocalTimetable();
            return const TimetablePage();
          }
          return _buildCombinedPage(context);
        },
      ),
    );
  }

  Widget _buildCombinedPage(BuildContext context) {
    final shadcon = ShadTheme.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/core/assets/BG.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 32),
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
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      "Roll Number",
                      style: shadcon.textTheme.h4,
                    ),
                  ),
                  const SizedBox(height: 4),
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
                  const SizedBox(height: 4),
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
                                const SizedBox(width: 8),
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
                  ),
                  // const SizedBox(height: 16),
                  // Center(
                  //   child: Text(
                  //     'OR',
                  //     style: shadcon.textTheme.h4,
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // ShadButton(
                  //   icon: const Icon(LucideIcons.logIn),
                  //   width: double.infinity,
                  //   height: 56,
                  //   onPressed: () {
                  //     context.read<AuthCubit>().signInWithGoogle();
                  //   },
                  //   child: const Text('Sign in with Google'),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
