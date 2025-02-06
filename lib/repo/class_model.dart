// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClassModel {
  final String subject;
  final String time;
  final String room;
  final int clockTime;

  ClassModel({
    required this.subject,
    required this.time,
    required this.room,
    required this.clockTime,
  });

  factory ClassModel.fromJson(Map<String, dynamic> map) {
    return ClassModel(
      subject: map['Subject'] as String,
      time: map['Time'] as String,
      room: map['Room'] as String,
      clockTime: map['Time_Sort'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'Subject': subject,
        'Time': time,
        'Room': room,
        'Time_Sort': clockTime,
      };
}
