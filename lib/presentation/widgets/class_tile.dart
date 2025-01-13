import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ClassTile extends StatelessWidget {
  const ClassTile({
    super.key,
    required this.classroom,
  });

  final Map<String, dynamic> classroom;

  @override
  Widget build(BuildContext context) {
    final shadcon = ShadTheme.of(context);
    return ShadCard(
      padding: const EdgeInsets.all(16),
      rowCrossAxisAlignment: CrossAxisAlignment.center,
      title: Text(
        classroom['Subject'],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: shadcon.colorScheme.primary,
        ),
      ),
      description: Text(
        classroom['Room'],
        style: TextStyle(
          fontSize: 20,
          color: shadcon.colorScheme.foreground,
        ),
      ),
      trailing: Text(
        classroom['Time'],
        style: TextStyle(
          fontSize: 28,
          color: shadcon.colorScheme.foreground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
