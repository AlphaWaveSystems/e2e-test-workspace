class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'backlog',
      priority: json['priority'] ?? 'medium',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
