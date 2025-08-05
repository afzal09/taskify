import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatbytes_assignment/features/tasks/data/models/task_model.dart';
import 'package:whatbytes_assignment/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRemoteDataSource {
  Future<void> createTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String taskId, String userId);
  Future<List<TaskEntity>> getTasksByUser(String userId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await firestore.collection('tasks').add(model.toMap());
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    if (task.id == null) {
      throw ArgumentError('Task ID is required to update.');
    }
    final model = TaskModel.fromEntity(task);
    await firestore.collection('tasks').doc(task.id).update(model.toMap());
  }

  @override
  Future<void> deleteTask(String taskId, String userId) async {
    print(FirebaseAuth.instance.currentUser?.uid);
    await firestore.collection('tasks').doc(taskId).delete();
  }

  @override
  Future<List<TaskEntity>> getTasksByUser(String userId) async {
    final querySnapshot = await firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => TaskModel.fromDocumentSnapshot(doc).toEntity())
        .toList();
  }
}
