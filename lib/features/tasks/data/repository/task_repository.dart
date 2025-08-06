import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatbytes_assignment/features/tasks/data/datasources/task_datasource.dart';
import 'package:whatbytes_assignment/features/tasks/domain/entities/task_entity.dart';
import 'package:whatbytes_assignment/features/tasks/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  // @override
  // Future<void> createTask(TaskEntity task) async {
  //   return remoteDataSource.createTask(task);
  // }
  final firestore = FirebaseFirestore.instance;
  @override
  Future<void> createTask(TaskEntity task) async {
    return remoteDataSource.createTask(task);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    return remoteDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId, String userId) async {
    return remoteDataSource.deleteTask(taskId, userId);
  }

  @override
  Future<List<TaskEntity>> getUserTasks(String userId) {
    return remoteDataSource.getTasksByUser(userId);
  }
}