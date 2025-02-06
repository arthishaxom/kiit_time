import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static const String _notiOffsetKey =
      "notification_offset"; // Key to store offset

  // Save user preference for notification offset (in minutes)
  static Future<void> setNotificationOffset(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_notiOffsetKey, minutes);
  }

  // Get the stored notification offset, default is 15 minutes
  static Future<int> getNotificationOffset() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_notiOffsetKey) ?? 15;
  }
}
