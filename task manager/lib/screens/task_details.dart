import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task_model.dart';
import 'package:task_manager_app/screens/home.dart';
import 'package:task_manager_app/services/storage_service.dart';
import '../helpers/field_widgets.dart';
import '../helpers/helpers.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onTaskUpdated;

  const TaskDetailScreen(
      {super.key, required this.task, required this.onTaskUpdated});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;
  late bool _isEditing;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _storageService = StorageService();

  String? _titleError;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _isEditing = false;
    _titleController.text = _task.title;
    _descriptionController.text = _task.description;

    _titleController.addListener(() {
      if (_titleError != null && _titleController.text.trim().isNotEmpty) {
        setState(() {
          _titleError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = HomeScreenState.getDialogTitle(_task.category);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_isEditing) {
          Navigator.of(context).pop();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.greenAccent[700]),
            onPressed: () {
              if (_isEditing) {
                Navigator.of(context).pop();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text('$title Task Details',
              style: TextStyle(color: Colors.greenAccent[700])),
          actions: [
            if (!_isEditing)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.greenAccent[700]),
                  onPressed: _startEditing,
                ),
              ),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: Icon(Icons.save, color: Colors.greenAccent[700]),
                  onPressed: _saveChanges,
                ),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isEditing)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title:',
                        style: TextStyle(
                            color: Colors.greenAccent[700], fontSize: 17),
                      ),
                      TaskTitleField(
                        controller: _titleController,
                        errorText: _titleError,
                      ),
                    ],
                  ),
                if (!_isEditing)
                  _buildDetailItem('Title:', _task.title, Colors.white),
                const SizedBox(height: 16),
                if (_isEditing)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(
                            color: Colors.greenAccent[700], fontSize: 17),
                      ),
                      TaskDescriptionField(
                        controller: _descriptionController,
                      ),
                    ],
                  ),
                if (!_isEditing)
                  _buildDetailItem(
                      'Description:', _task.description, Colors.white),
                const SizedBox(height: 16),
                _buildDetailItem(
                  'Date:',
                  Helpers.formattedDateTime(_task.dateTime),
                  Colors.green[200]!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _titleError = null;
    });
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.trim().isEmpty) {
      setState(() {
        _titleError = "Title can't be empty";
      });
      return;
    } else if (_titleController.text.trim().isNotEmpty) {
      setState(() {
        _titleError = null;
      });
    }

    final updatedTask = Task(
      id: _task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: _task.dateTime,
      category: _task.category,
      isCompleted: _task.isCompleted,
    );

    setState(() {
      _task = updatedTask;
      _isEditing = false;
      _titleError = null;
    });
    await _storageService.saveTasks({
      _task.category: [_task],
    });
    widget.onTaskUpdated(_task);
  }

  Widget _buildDetailItem(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.greenAccent[700], fontSize: 17),
        ),
        const SizedBox(height: 4),
        SelectableText(value, style: TextStyle(color: textColor, fontSize: 16)),
      ],
    );
  }
}
