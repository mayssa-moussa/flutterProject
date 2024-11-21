import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_edit_session_screen.dart';
import '../models/session.dart';
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
    final String response = await rootBundle.loadString('assets/json/db.json');
    final data = json.decode(response);
    final sessionList = data['sessions'] as List;

    setState(() {
      sessions = sessionList.map((sessionJson) => Session.fromJson(sessionJson)).toList();
    });
  }

  // Save sessions back to db (in this case, we just print it)
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
    setState(() {
      sessions.removeWhere((s) => s.sessionId == session.sessionId);
    });
    saveSessions();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Timetable'),
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
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
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _getSessionsForDay(_selectedDay).length,
            itemBuilder: (context, index) {
              final session = _getSessionsForDay(_selectedDay)[index];
              return ListTile(
                title: Text('${session.subjectId}'),
                subtitle: Text('${session.startTime} - ${session.endTime}'),
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
      child: Icon(Icons.add),
    ),
  );
}
}
