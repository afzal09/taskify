import 'package:equatable/equatable.dart';
import 'package:whatbytes_assignment/features/tasks/domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final String userId;

  const LoadTasks(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateTask extends TaskEvent {
  final TaskEntity task;

  const CreateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final TaskEntity task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;
  final String userId;

  const DeleteTask(this.taskId, this.userId);

  @override
  List<Object?> get props => [taskId, userId];
}