import 'package:flutter/material.dart';
import '../models/session.dart';

class AddEditSessionScreen extends StatefulWidget {
  final Session? session;

  AddEditSessionScreen({this.session});

  @override
  _AddEditSessionScreenState createState() => _AddEditSessionScreenState();
}

class _AddEditSessionScreenState extends State<AddEditSessionScreen> {
  late TextEditingController _subjectController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late DateTime _sessionDate;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.session?.subjectId ?? '');
    _startTimeController = TextEditingController(text: widget.session?.startTime ?? '');
    _endTimeController = TextEditingController(text: widget.session?.endTime ?? '');
    _sessionDate = DateTime.parse(widget.session?.sessionDate ?? DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session == null ? 'Add Session' : 'Edit Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _startTimeController,
              decoration: InputDecoration(labelText: 'Start Time'),
            ),
            TextField(
              controller: _endTimeController,
              decoration: InputDecoration(labelText: 'End Time'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _sessionDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null && pickedDate != _sessionDate) {
                  setState(() {
                    _sessionDate = pickedDate;
                  });
                }
              },
              child: Text('Select Date'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // On Save, create a new session and pass it back
                final updatedSession = Session(
                  sessionId: widget.session?.sessionId ?? DateTime.now().toString(),
                  subjectId: _subjectController.text,
                  teacherId: widget.session?.teacherId ?? '',
                  roomId: widget.session?.roomId ?? '',
                  classId: widget.session?.classId ?? '',
                  sessionDate: _sessionDate.toIso8601String(), // Use the selected date
                  startTime: _startTimeController.text,
                  endTime: _endTimeController.text,
                );
                Navigator.pop(context, updatedSession); // Return the updated session
              },
              child: Text(widget.session == null ? 'Add Session' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
