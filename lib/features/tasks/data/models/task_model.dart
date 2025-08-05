import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatbytes_assignment/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.dueDate,
    super.priority,
    super.isCompleted,
  });

  /// Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.name,
      'isCompleted': isCompleted,
    };
  }

  /// Create model from Firestore document snapshot
  factory TaskModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      userId: data['userId'],
      title: data['title'],
      description: data['description'],
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: Priority.values.firstWhere(
        (e) => e.name == data['priority'],
        orElse: () => Priority.medium,
      ),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  /// Create model from entity
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      priority: entity.priority,
      isCompleted: entity.isCompleted,
    );
  }

  /// Convert model back to entity
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      userId: userId,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      isCompleted: isCompleted,
    );
  }
}
