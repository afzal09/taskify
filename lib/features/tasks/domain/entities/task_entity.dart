enum Priority { low, medium, high }

class TaskEntity {
  final String? id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;
  final bool isCompleted;

  TaskEntity({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.priority = Priority.medium,
    this.isCompleted = false,
  });
}
