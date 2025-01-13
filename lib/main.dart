// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:kiittime/presentation/bloc/timetable/timetable_cubit.dart';
import 'package:kiittime/presentation/pages/home_page.dart';
import 'package:kiittime/repo/class_repo.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  var timetableBox = await Hive.openBox('timetable');

  // Initialize Supabase
  await Supabase.initialize(
    url: const String.fromEnvironment('URL'),
    anonKey: const String.fromEnvironment('ANON'),
  );

  // Create an instance of the repository
  var timetableRepository = TimetableRepository(
    supabase: Supabase.instance.client,
    timetableBox: timetableBox,
  );
  runApp(
    MyApp(
      timetableRepository: timetableRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final TimetableRepository timetableRepository;

  const MyApp({
    super.key,
    required this.timetableRepository,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimetableCubit(timetableRepository),
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
