import 'package:bloc/bloc.dart';
import 'package:whatbytes_assignment/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:whatbytes_assignment/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:whatbytes_assignment/features/tasks/domain/usecases/get_tasks_stream_usecase.dart';
import 'package:whatbytes_assignment/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:whatbytes_assignment/features/tasks/presentation/blocs/task_event.dart';
import 'package:whatbytes_assignment/features/tasks/presentation/blocs/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetTasksUseCase getTasksByUserUseCase;

  TaskBloc({
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getTasksByUserUseCase,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksByUserUseCase(event.userId);
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    }
  }

  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    try {
      await addTaskUseCase(event.task);
      add(LoadTasks(event.task.userId));
    } catch (e) {
      emit(TaskError('Failed to create task: $e'));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await updateTaskUseCase(event.task);
      add(LoadTasks(event.task.userId));
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await deleteTaskUseCase(event.taskId, event.userId);
      add(LoadTasks(event.userId));
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }
}
