import 'package:flutter/material.dart';
import 'package:kiittime/theme/extensions.dart';

class ClassTile extends StatelessWidget {
  const ClassTile({
    super.key,
    required this.classroom,
  });

  final Map<String, dynamic> classroom;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: context.colorScheme.surfaceDim,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2, color: context.colorScheme.outlineVariant)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          classroom['Subject'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28,color: context.colorScheme.onSurface),
        ),
        subtitle: Text(
          classroom['Room'],
          style: TextStyle(fontSize: 20,color: context.colorScheme.onSurface),
        ),
        trailing: Text(
          classroom['Time'],
          style: TextStyle(fontSize: 28, color: context.colorScheme.primary),
        ),
      ),
    );
  }
}
