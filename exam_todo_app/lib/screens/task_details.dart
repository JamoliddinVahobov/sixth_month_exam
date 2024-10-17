import 'package:exam_todo_app/models/task_model.dart';
import 'package:exam_todo_app/screens/home.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final title = HomeScreenState.getDialogTitle(task.category);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.greenAccent[700]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('$title Details',
            style: TextStyle(color: Colors.greenAccent[700])),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Task:', task.title, Colors.white),
            const SizedBox(height: 16),
            _buildDetailItem('Description:', task.description, Colors.white),
            const SizedBox(height: 16),
            _buildDetailItem(
              'Date:',
              formattedDateTime(task.dateTime),
              Colors.green[200]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: Colors.greenAccent[700], fontSize: 17)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: textColor, fontSize: 16)),
      ],
    );
  }
}
