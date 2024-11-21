// In shared_preferences_helper.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  // Save login state
  static Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);  // Save login state
  }

  // Get login state
  static Future<bool?> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn');  // Retrieve login state
  }

  // Save sessions
  static Future<void> saveSessions(List<Map<String, dynamic>> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    String sessionsJson = jsonEncode(sessions);
    await prefs.setString('sessions', sessionsJson);
  }

  // Load sessions
  static Future<List<Map<String, dynamic>>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedSessions = prefs.getString('sessions');
    
    if (storedSessions != null) {
      List<dynamic> sessionList = jsonDecode(storedSessions);
      return sessionList.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];  // Return an empty list if no sessions are found
  }
}
