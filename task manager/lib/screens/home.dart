import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task_model.dart';
import 'package:task_manager_app/screens/task_details.dart';
import 'package:task_manager_app/services/storage_service.dart';

import 'tasklist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = ['Default', 'Personal', 'Study', 'Work'];
  late Map<String, List<Task>> tasks;
  final StorageService _storageService = StorageService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await _storageService.loadTasks();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveTasks() async {
    await _storageService.saveTasks(tasks);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Colors.greenAccent.shade700),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Today's Tasks",
          style: TextStyle(color: Colors.greenAccent[700]),
        ),
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: categories.map((category) => Tab(text: category)).toList(),
          labelColor: Colors.greenAccent[700],
          indicatorColor: Colors.greenAccent[700],
          indicatorWeight: 3,
          unselectedLabelColor: Colors.green[200],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories
            .map((category) => TaskList(
                  tasks: tasks[category]!,
                  onDelete: (task) => _deleteTask(task, category),
                  onToggle: (task) => _toggleTask(task, category),
                  onTap: (task) => _showTaskDetails(task),
                ))
            .toList(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15, bottom: 40),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.greenAccent[700],
          child: const Icon(Icons.add, color: Colors.black, size: 30),
          onPressed: () => _showAddTaskDialog(context),
        ),
      ),
    );
  }

  void _deleteTask(Task task, String category) async {
    setState(() {
      tasks[category]!.remove(task);
    });
    await _saveTasks();
  }

  void _toggleTask(Task task, String category) async {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    await _saveTasks();
  }

  static String getDialogTitle(String category) {
    switch (category) {
      case 'Default':
        return 'Default';
      case 'Personal':
        return 'Personal';
      case 'Study':
        return 'Study';
      case 'Work':
        return 'Work';
      default:
        return category;
    }
  }

  void _showAddTaskDialog(BuildContext context) async {
    final TextEditingController taskController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    final result = await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 20, 15, 30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adding ${getDialogTitle(categories[_tabController.index])} Task',
                style: TextStyle(
                  color: Colors.greenAccent[700],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                cursorColor: Colors.purple[500],
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'Task',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                cursorColor: Colors.purple[500],
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text('Pick Date',
                        style: TextStyle(color: Colors.green[500])),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) selectedDate = date;
                    },
                  ),
                  TextButton(
                    child: Text('Pick Time',
                        style: TextStyle(color: Colors.green[500])),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (time != null) selectedTime = time;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('Close',
                        style: TextStyle(color: Colors.purple[500])),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    child: Text('Add',
                        style: TextStyle(color: Colors.purple[500])),
                    onPressed: () {
                      if (taskController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.grey[800],
                            content: const Text(
                              "Task can't be empty",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        Navigator.pop(context, {
                          'title': taskController.text,
                          'description': descController.text,
                          'date': selectedDate,
                          'time': selectedTime,
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null) {
      final newTask = Task(
        id: DateTime.now().toString(),
        title: result['title'],
        description: result['description'],
        dateTime: DateTime(
          result['date'].year,
          result['date'].month,
          result['date'].day,
          result['time'].hour,
          result['time'].minute,
        ),
        category: categories[_tabController.index],
      );

      setState(() {
        tasks[categories[_tabController.index]]!.add(newTask);
      });
      await _saveTasks();
    }
  }

  void _showTaskDetails(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
  }
}
