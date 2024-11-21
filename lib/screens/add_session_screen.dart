import 'package:flutter/material.dart';
import '../models/session.dart';

class AddEditSessionScreen extends StatefulWidget {
  final Session? session;

  // Constructor to optionally pass a session for editing
  AddEditSessionScreen({Key? key, this.session}) : super(key: key);

  @override
  _AddEditSessionScreenState createState() => _AddEditSessionScreenState();
}

class _AddEditSessionScreenState extends State<AddEditSessionScreen> {
  late TextEditingController subjectController;
  late TextEditingController teacherController;
  late TextEditingController roomController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController sessionDateController;

  // Initialize controllers in initState
  @override
  void initState() {
    super.initState();
    subjectController = TextEditingController(text: widget.session?.subjectId ?? '');
    teacherController = TextEditingController(text: widget.session?.teacherId ?? '');
    roomController = TextEditingController(text: widget.session?.roomId ?? '');
    startTimeController = TextEditingController(text: widget.session?.startTime ?? '');
    endTimeController = TextEditingController(text: widget.session?.endTime ?? '');
    sessionDateController = TextEditingController(text: widget.session?.sessionDate ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.session == null ? 'Add Session' : 'Edit Session')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Subject ID
            TextField(
              controller: subjectController,
              decoration: InputDecoration(labelText: 'Subject ID'),
            ),
            // Teacher ID
            TextField(
              controller: teacherController,
              decoration: InputDecoration(labelText: 'Teacher ID'),
            ),
            // Room ID
            TextField(
              controller: roomController,
              decoration: InputDecoration(labelText: 'Room ID'),
            ),
            // Start Time
            TextField(
              controller: startTimeController,
              decoration: InputDecoration(labelText: 'Start Time'),
            ),
            // End Time
            TextField(
              controller: endTimeController,
              decoration: InputDecoration(labelText: 'End Time'),
            ),
            // Session Date
            TextField(
              controller: sessionDateController,
              decoration: InputDecoration(labelText: 'Session Date (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
            // Save button
            ElevatedButton(
              onPressed: () {
                final newSession = Session(
                  sessionId: widget.session?.sessionId ?? DateTime.now().toString(), // Generate new ID if it's a new session
                  subjectId: subjectController.text,
                  teacherId: teacherController.text,
                  roomId: roomController.text,
                  classId: '', // Assuming we don't need to set this for now
                  sessionDate: sessionDateController.text,
                  startTime: startTimeController.text,
                  endTime: endTimeController.text,
                );

                // Return the session to the previous screen
                Navigator.pop(context, newSession);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
