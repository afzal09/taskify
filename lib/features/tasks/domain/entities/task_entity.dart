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

    TaskEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
