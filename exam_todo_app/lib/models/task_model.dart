class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    this.isCompleted = false,
  });

  // Convert task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  // Create task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      category: json['category'],
      isCompleted: json['isCompleted'],
    );
  }
}
