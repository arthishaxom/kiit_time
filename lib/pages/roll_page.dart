import 'package:flutter/material.dart';
import 'package:kiittime/components/logo_text.dart';
import 'package:kiittime/pages/timetable_page.dart';
import 'package:kiittime/theme/extensions.dart';

class RollPage extends StatefulWidget {
  const RollPage({super.key});

  @override
  State<RollPage> createState() => _RollPageState();
}

class _RollPageState extends State<RollPage> {
  TextEditingController rollController = TextEditingController();

  String _errorText = "Default";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: LogoText(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Time In Your Hand",
                      style: TextStyle(
                          fontSize: 16, color: context.colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                      child: Text(
                        "Roll Number",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: rollController,
                      maxLength: 8,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.colorScheme.surfaceDim,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 2,
                            color: context.colorScheme.outline,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              width: 2,
                            )),
                        hintText: '00000000',
                        hintStyle:
                            TextStyle(color: context.colorScheme.outline),
                        counterText: '',
                        errorStyle: TextStyle(
                            color: context.colorScheme.errorContainer),
                        errorText: _errorText == "Default" ? null : _errorText,
                        helper: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "If your roll is 7 digits, then just enter the 7 digits and submit.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: context.colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: _validateInput,
                      style: TextStyle(
                          fontSize: 20, color: context.colorScheme.onSurface),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _validateInput(rollController.text);
                      if (_errorText == "Default") {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                TimeTablePage(rollNumber: rollController.text),
                            settings: RouteSettings(
                                name: '/timetable',
                                arguments: {'rollNumber': rollController.text}),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  color: context.colorScheme.inverseSurface,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  _errorText,
                                  style: TextStyle(
                                      color: context.colorScheme.onSurface),
                                ),
                              ],
                            ),
                            backgroundColor: context.colorScheme.errorContainer,
                            behavior: SnackBarBehavior.floating,
                            width: 400,
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
