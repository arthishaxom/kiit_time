import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kiittime/models/timetable_model.dart';
import 'package:kiittime/pages/home_page.dart';
import 'package:kiittime/pages/intro_page.dart';
import 'package:kiittime/pages/timetable_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['URL']!,
    anonKey: dotenv.env['ANON']!,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => TimeTableModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 255, 134, 35),
            secondary: Color.fromARGB(255, 255, 228, 188)),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      routes: {
        '/timetable': (context) => const TimeTablePage(),
        '/homepage':(context) => const HomePage(),
      },
    );
  }
}
