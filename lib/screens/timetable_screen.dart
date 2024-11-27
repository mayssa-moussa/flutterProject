import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_edit_session_screen.dart';
import '../models/session.dart';
import '../shared_preferences_helper.dart';
import 'login_screen.dart';

class TimetableScreen extends StatefulWidget {
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List<Session> sessions = [];
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    loadSessions();
  }

  // Load sessions from db.json
  Future<void> loadSessions() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/db.json');
      final data = json.decode(response);
      final sessionList = data['sessions'] as List;

      setState(() {
        sessions = sessionList
            .map((sessionJson) => Session.fromJson(sessionJson))
            .toList();
      });
    } catch (e) {
      print('Error loading sessions: $e');
    }
  }

  // Save sessions back to db (mock behavior for now)
  Future<void> saveSessions() async {
    final updatedJson = jsonEncode({
      'sessions': sessions.map((session) => session.toJson()).toList(),
    });

    print("Updated JSON Data: $updatedJson");
  }

  // Filter sessions for the selected day
  List<Session> _getSessionsForDay(DateTime day) {
    return sessions.where((session) {
      final sessionDate = DateTime.parse(session.sessionDate);
      return sessionDate.year == day.year &&
          sessionDate.month == day.month &&
          sessionDate.day == day.day;
    }).toList();
  }

  // Edit session
  void _editSession(Session session) async {
    final updatedSession = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditSessionScreen(session: session),
      ),
    );

    if (updatedSession != null) {
      setState(() {
        sessions = sessions.map<Session>((s) {
          return s.sessionId == updatedSession.sessionId ? updatedSession : s;
        }).toList();
      });
      saveSessions();
    }
  }

  // Delete session
  void _deleteSession(Session session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Session', style: TextStyle(color: Colors.red)),
        content: Text('Are you sure you want to delete this session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                sessions.removeWhere((s) => s.sessionId == session.sessionId);
              });
              saveSessions();
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Logout
  Future<void> _logout() async {
    final confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: TextStyle(color: Colors.red)),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      // Clear login state and navigate to LoginScreen
      await SharedPreferencesHelper.clearLoginState();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Blue color for the AppBar
        title: Text('Timetable', style: TextStyle(fontFamily: 'Roboto')),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 01, 01),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month, // Always show month view
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month', // Disable week view
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: Icon(Icons.arrow_back, color: Colors.blue),
              rightChevronIcon: Icon(Icons.arrow_forward, color: Colors.blue),
              decoration: BoxDecoration(
                color: Colors.white, // White color for the calendar header
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(color: Colors.black),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.orange, // Color for the selected day
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.green, // Color for the today day
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
          ),
          Expanded(
            child: _getSessionsForDay(_selectedDay).isEmpty
                ? Center(child: Text('No sessions for this day.'))
                : ListView.builder(
                    itemCount: _getSessionsForDay(_selectedDay).length,
                    itemBuilder: (context, index) {
                      final session = _getSessionsForDay(_selectedDay)[index];
                      return Card(
                        color: Colors.grey[200], // Light gray background for cards
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadowColor: Colors.black45,
                        elevation: 5,
                        child: ListTile(
                          title: Text(
                            '${session.subjectId}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue), // Blue text
                          ),
                          subtitle: Text(
                            '${session.startTime} - ${session.endTime}\n${session.sessionDate}',
                            style: TextStyle(color: Colors.black87),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editSession(session),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteSession(session),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newSession = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditSessionScreen()),
          );

          if (newSession != null) {
            setState(() {
              sessions.add(newSession);
            });
            saveSessions();
          }
        },
        backgroundColor: Colors.blue, // Blue for the button
        child: Icon(Icons.add),
      ),
    );
  }
}
