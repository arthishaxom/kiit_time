import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:kiittime/models/theme_provider.dart';
import 'package:kiittime/models/timetable_model.dart';
import 'package:kiittime/pages/intro_page.dart';
import 'package:kiittime/pages/roll_page.dart';
import 'package:kiittime/pages/timetable_page.dart';
import 'package:kiittime/theme/dark_theme.dart';
import 'package:kiittime/theme/light_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final dir = await getApplicationDocumentsDirectory();
  // Hive.defaultDirectory = dir.path;

  await Hive.initFlutter();
  await Hive.openBox('timetable');

  await Supabase.initialize(
    url: const String.fromEnvironment('URL'),
    anonKey: const String.fromEnvironment('ANON'),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TimeTableModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const IntroPage(),
          theme: lightTheme.copyWith(
              textTheme: GoogleFonts.latoTextTheme(lightTheme.textTheme)),
          darkTheme: darkTheme.copyWith(
              textTheme: GoogleFonts.latoTextTheme(lightTheme.textTheme)),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          onGenerateRoute: (settings) {
            if (settings.name == '/timetable') {
              final args = settings.arguments as Map<String, String>;
              final rollNumber = args['rollNumber'] ?? '22053062';
              return MaterialPageRoute(
                builder: (context) => TimeTablePage(rollNumber: rollNumber),
              );
            } else if (settings.name == '/roll') {
              return MaterialPageRoute(
                builder: (context) => const RollPage(),
              );
            }
            // Default route (you might want to adjust this based on your app's structure)
            return MaterialPageRoute(
              builder: (context) => const IntroPage(),
            );
          },
        );
      },
    );
  }
}
