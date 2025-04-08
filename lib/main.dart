// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:kiittime/presentation/bloc/auth/auth_cubit.dart';
import 'package:kiittime/presentation/pages/home_page.dart';
import 'package:kiittime/repo/noti_repo.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kiittime/presentation/bloc/timetable/timetable_cubit.dart';
// import 'package:kiittime/presentation/pages/home_page.dart';
import 'package:kiittime/repo/auth_repo.dart';
import 'package:kiittime/repo/class_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  NotiService().initNotification();

  // Initialize Hive
  await Hive.initFlutter();
  var timetableBox = await Hive.openBox('timetable');

  // Initialize Supabase
  await Supabase.initialize(
    url: const String.fromEnvironment('URL'),
    anonKey: const String.fromEnvironment('ANON'),
  );
  final supabaseClient = Supabase.instance.client;
  // Create an instance of the repository
  var timetableRepository = TimetableRepository(
    supabase: supabaseClient,
    timetableBox: timetableBox,
  );

  var authRepo = AuthRepository(
    supabaseClient: supabaseClient,
  );
  runApp(
    MyApp(
      timetableRepository: timetableRepository,
      authRepository: authRepo,
    ),
  );
}

class MyApp extends StatelessWidget {
  final TimetableRepository timetableRepository;
  final AuthRepository authRepository;

  const MyApp({
    super.key,
    required this.timetableRepository,
    required this.authRepository,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimetableCubit(timetableRepository),
        ),
        BlocProvider(
          create: (context) => AuthCubit(authRepository),
        ),
      ],
      child: ShadApp(
        debugShowCheckedModeBanner: false,
        title: 'KIIT TIME',
        themeMode: ThemeMode.dark,
        darkTheme: ShadThemeData(
          colorScheme: const ShadOrangeColorScheme.dark(),
          brightness: Brightness.dark,
          textTheme: ShadTextTheme.fromGoogleFont(
            GoogleFonts.poppins,
            // colorScheme: const ShadZincColorScheme.dark(),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
