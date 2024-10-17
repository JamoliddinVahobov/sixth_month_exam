import 'dart:convert';
import 'package:exam_todo_app/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String tasksKey = 'tasks';

  // Save all tasks
  Future<void> saveTasks(Map<String, List<Task>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTasks = json.encode(tasks.map(
      (category, tasks) => MapEntry(
        category,
        tasks.map((task) => task.toJson()).toList(),
      ),
    ));
    await prefs.setString(tasksKey, encodedTasks);
  }

  // Load all tasks
  Future<Map<String, List<Task>>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(tasksKey);

    if (tasksString == null) {
      return {
        'Personal': [],
        'Default': [],
        'Study': [],
        'Work': [],
      };
    }

    final Map<String, dynamic> decodedTasks = json.decode(tasksString);
    return decodedTasks.map((category, tasksList) => MapEntry(
          category,
          (tasksList as List)
              .map((taskMap) =>
                  Task.fromJson(Map<String, dynamic>.from(taskMap)))
              .toList(),
        ));
  }
}
