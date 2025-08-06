import 'package:whatbytes_assignment/features/tasks/domain/entities/task_entity.dart';
import 'package:whatbytes_assignment/features/tasks/domain/repository/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase({required this.repository});

  Future<void> call(TaskEntity task) async {
    return await repository.createTask(task);
  }
}
