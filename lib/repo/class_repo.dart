import 'package:hive_ce/hive.dart';
import 'package:kiittime/core/utils/days.dart';
import 'package:kiittime/repo/class_model.dart';
import 'package:kiittime/repo/noti_repo.dart';
import 'package:kiittime/repo/pref_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

class TimetableRepository {
  static const _sectionBoxKey = 'sections';
  final Constants daysConstants = Constants();
  final NotiService notiService = NotiService();

  final SupabaseClient supabase;
  final Box<dynamic> timetableBox;

  TimetableRepository({required this.supabase, required this.timetableBox});

  Future<void> fetchAndStoreTimetable(String roll) async {
    try {
      final collegeYear = _calculateCollegeYear(roll);
      final tableName = 'year${collegeYear}_tt';
      final sections = await _fetchSections(roll, collegeYear);

      if (sections.isEmpty) {
        throw Exception('No sections found for roll $roll');
      }

      await _storeSections(roll, sections);
      await _fetchAndStoreTimetableData(tableName, sections);
      await scheduleAllClassNotifications();
    } catch (e) {
      throw Exception('Failed to fetch timetable: ${e.toString()}');
    }
  }

  int _calculateCollegeYear(String roll) {
    if (roll.length < 5) {
      throw Exception('Invalid roll number format');
    }

    final admissionYear = int.parse(roll.substring(0, 2));
    final currentYear = DateTime.now().year % 100;
    var collegeYear = currentYear - admissionYear + 1;

    if (DateTime.now().month < 7) {
      collegeYear -= 1;
    }

    // Handle lateral entry students (5th character is '7')
    if (roll[4] == '7') {
      collegeYear = (collegeYear + 1).clamp(2, 4);
    }

    return collegeYear.clamp(1, 4);
  }

  Future<List<String>> _fetchSections(String roll, int collegeYear) async {
    final response = await supabase
        .from('year${collegeYear}_sections')
        .select('Section')
        .eq('Roll', roll);

    return response.map<String>((e) => e['Section'] as String).toList();
  }

  Future<void> _storeSections(String roll, List<String> sections) async {
    final sectionData = {
      'roll': roll,
      'sections': sections,
    };
    await timetableBox.putAll(sectionData);
  }

  Future<void> _fetchAndStoreTimetableData(
    String tableName,
    List<String> sections,
  ) async {
    // Get days in correct format (Mon, Tue, etc.)
    final days = daysConstants.daysIndex.keys.toList();

    for (final dayAbbrev in days) {
      try {
        final data = await supabase
            .from(tableName)
            .select()
            .inFilter('Section', sections)
            .eq('Day', dayAbbrev.toUpperCase())
            .order('Time_Sort', ascending: true);

        final classes = data.map((e) => ClassModel.fromJson(e)).toList();

        // Store using uppercase day abbreviation (MON, TUE, etc.)
        await timetableBox.put(
          dayAbbrev.toUpperCase(),
          classes.map((e) => e.toJson()).toList(),
        );
      } catch (e) {
        throw Exception('Failed to fetch data for $dayAbbrev: ${e.toString()}');
      }
    }
  }

  // Helper to get current day's timetable
  List<ClassModel>? getTodaysTimetable() {
    final currentDayIndex = daysConstants.getDayIndex();
    final dayAbbrev = daysConstants.daysIndex.keys.elementAt(currentDayIndex);
    return getTimetableForDay(dayAbbrev);
  }

  List<ClassModel>? getTimetableForDay(String dayAbbrev) {
    final data = timetableBox.get(dayAbbrev.toUpperCase());
    if (data is List) {
      return data.map((e) {
        final Map<String, dynamic> jsonData =
            Map<String, dynamic>.from(e as Map);
        return ClassModel.fromJson(jsonData);
      }).toList();
    }
    return null;
  }

  List<String>? getSections() {
    final data = timetableBox.get(_sectionBoxKey);
    return data?['sections']?.cast<String>();
  }

  int _generateNotiId(String day, int index) {
    return day.hashCode + index; // Unique ID based on day and index
  }

  tz.TZDateTime getNextInstanceOfDayAndTime(
      int targetWeekday, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // If the scheduled time is already past for today, move to the next occurrence
    if (scheduledDate.isBefore(now) || scheduledDate.weekday != targetWeekday) {
      int daysUntilNext = (targetWeekday - now.weekday) % 7;
      if (daysUntilNext <= 0) daysUntilNext += 7; // Ensure it's in the future
      scheduledDate = scheduledDate.add(Duration(days: daysUntilNext));
    }

    return scheduledDate;
  }

  Future<tz.TZDateTime?> _calculateNotificationTime(
      int classHour,
      int classMinute,
      int targetDayIndex, // This is the index from your constants (0 for Mon, ..., 5 for Sat)
      int notiOffset) async {
    // Convert your 0-based day index to the 1-based weekday number used by DateTime
    final int targetWeekday = targetDayIndex + 1; // e.g., 0 becomes 1 (Monday)

    // Get the next occurrence of the target weekday at the class start time.
    // Then subtract 15 minutes for the notification.
    final tz.TZDateTime classTime =
        getNextInstanceOfDayAndTime(targetWeekday, classHour, classMinute);
    return classTime.subtract(Duration(minutes: notiOffset));
  }

  Future<void> scheduleAllClassNotifications() async {
    await notiService.cancelAllNoti(); // Clear old notifications
    final int notiOffset = await PrefsHelper.getNotificationOffset();

    final days = daysConstants.daysIndex.keys
        .toList(); // e.g. ['Mon', 'Tue', ..., 'Sat']

    for (var day in days) {
      final timetable = getTimetableForDay(day);
      if (timetable == null || timetable.isEmpty) continue;

      // Get the day index (0 for Mon, ... 5 for Sat) and convert to weekday (1 for Mon, ... 6 for Sat)
      final int dayIndex = daysConstants.daysIndex[day]!;
      // Convert to DateTime weekday value:
      // final int targetWeekday = dayIndex + 1;

      for (var i = 0; i < timetable.length; i++) {
        final classData = timetable[i];
        // Assuming your ClassModel has clockTime as hour (int) and clockMinutes as minute (int)
        final tz.TZDateTime? notificationTime =
            await _calculateNotificationTime(
                classData.clockTime,
                0, // if you have a minutes field; otherwise, use 0
                dayIndex,
                notiOffset);

        if (notificationTime == null) continue;
        String time = classData.clockTime < 12
            ? "${classData.clockTime} AM"
            : "${classData.clockTime == 12 ? 12 : classData.clockTime - 12} PM";
        await notiService.scheduleNoti(
          id: _generateNotiId(day, i),
          title: "Upcoming Class: ${classData.subject}",
          body: "At $time in ${classData.room}",
          scheduledDate: notificationTime, // Pass precomputed TZDateTime
        );
      }
    }
  }
}
