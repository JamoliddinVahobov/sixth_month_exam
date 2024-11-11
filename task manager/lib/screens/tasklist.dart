import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task_model.dart';
import '../helpers/helpers.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onDelete;
  final Function(Task) onToggle;
  final Function(Task) onTap;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onDelete,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Image.asset(
          'assets4/palm_trees.jpg',
          fit: BoxFit.contain,
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: Key(task.id),
          onDismissed: (_) => onDelete(task),
          child: ListTile(
            onTap: () => onTap(task),
            title: Text(
              task.title,
              style: TextStyle(
                color: Colors.greenAccent[700],
                fontSize: 16,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: Colors.yellow,
                decorationThickness: 2.5,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
            subtitle: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: Helpers.formattedDateTime(task.dateTime),
                    style: TextStyle(color: Colors.green[300], fontSize: 14),
                  ),
                ],
              ),
            ),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(task),
              activeColor: Colors.greenAccent[700],
            ),
          ),
        );
      },
    );
  }
}
