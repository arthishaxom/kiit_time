class ClassModel {
  final String subject;
  final String time;
  final String room;

  ClassModel({
    required this.subject,
    required this.time,
    required this.room,
  });

  factory ClassModel.fromJson(Map<String, dynamic> map) {
    return ClassModel(
      subject: map['Subject'],
      time: map['Time'],
      room: map['Room'],
    );
  }
}
