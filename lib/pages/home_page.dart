import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiittime/models/timetable_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final rollController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SvgPicture.asset(
                'lib/assets/logo.svg',
                fit: BoxFit.fitWidth,
                width: 100,
                colorFilter: const ColorFilter.mode(
                    Color.fromARGB(255, 33, 33, 33), BlendMode.srcIn),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.red),
                  ),
                  label: Text("Roll Number"),
                ),
                controller: rollController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : FilledButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        minimumSize:
                            const WidgetStatePropertyAll(Size.fromHeight(60)),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await Provider.of<TimeTableModel>(context,
                                listen: false)
                            .getSection(rollController.text);
                        await Provider.of<TimeTableModel>(context,
                                listen: false)
                            .getData();
                        
                        Navigator.pushReplacementNamed(context, '/timetable');
                      },
                      child: Container(
                        width: 180,
                        padding: const EdgeInsets.all(12),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Submit"),
                            Icon(Icons.navigate_next_rounded)
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
