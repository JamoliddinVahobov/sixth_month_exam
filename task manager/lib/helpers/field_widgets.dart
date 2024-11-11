import 'package:flutter/material.dart';

class TaskTitleField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;

  const TaskTitleField({
    super.key,
    required this.controller,
    this.errorText,
  });

  @override
  State<TaskTitleField> createState() => _TaskTitleFieldState();
}

class _TaskTitleFieldState extends State<TaskTitleField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: 2,
      cursorColor: Colors.purple,
      controller: widget.controller,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Task Title',
        hintStyle: const TextStyle(color: Colors.white54),
        errorText: widget.errorText,
        errorStyle: const TextStyle(color: Colors.red),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
        ),
      ),
    );
  }
}

class TaskDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const TaskDescriptionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: 100,
      cursorColor: Colors.purple,
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: const InputDecoration(
        hintText: 'Task Description',
        hintStyle: TextStyle(color: Colors.white54),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
        ),
      ),
    );
  }
}
