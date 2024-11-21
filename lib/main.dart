import 'package:flutter/material.dart';
import 'package:mycalender/screens/timetable_screen.dart';
import 'screens/login_screen.dart';
import 'shared_preferences_helper.dart';  // Import SharedPreferencesHelper

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timetable App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool?>(
        future: SharedPreferencesHelper.getLoginState(),  // Check login state on app start
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Show loading while checking login state
          }
          if (snapshot.hasData && snapshot.data == true) {
            return TimetableScreen();  // Navigate to HomePage if logged in
          } else {
            return LoginScreen();  // Otherwise, show login screen
          }
        },
      ),
    );
  }
}
