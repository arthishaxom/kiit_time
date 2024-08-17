import 'package:flutter/material.dart';

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          classroom['Subject'],
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 28),
        ),
        subtitle: Text(
          classroom['Room'],
          style: const TextStyle(fontSize: 20),
        ),
        trailing: Text(
          classroom['Time'],
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}