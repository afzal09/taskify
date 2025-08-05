import 'package:whatbytes_assignment/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String taskId, String userId);
  Future<List<TaskEntity>> getUserTasks(String userId);
}