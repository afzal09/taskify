import 'package:whatbytes_assignment/features/tasks/domain/entities/task_entity.dart';
import 'package:whatbytes_assignment/features/tasks/domain/repository/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase({required this.repository});

  Future<List<TaskEntity>> call(String userId) {
    return repository.getUserTasks(userId);
  }
}
