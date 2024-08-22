import 'package:flutter/material.dart';
import 'package:kiittime/theme/extensions.dart';

class RollNotfound extends StatelessWidget {
  const RollNotfound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              child: Image.asset(
                'lib/assets/not_found.png',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "Roll Not Found",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.onSurface),
                    ),
                  ),
                  Text(
                    "Oops! Looks like you have given a wrong roll number.",
                    style: TextStyle(
                      fontSize: 16,
                      color: context.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/rollpage');
                },
                child: Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      "Retry",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
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
