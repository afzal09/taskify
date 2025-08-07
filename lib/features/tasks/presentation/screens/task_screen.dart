// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:whatbytes_assignment/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:whatbytes_assignment/features/tasks/domain/entities/task_entity.dart';
import 'package:whatbytes_assignment/features/tasks/presentation/blocs/task_bloc.dart';
import 'package:whatbytes_assignment/features/tasks/presentation/blocs/task_event.dart';
import 'package:whatbytes_assignment/features/tasks/presentation/blocs/task_state.dart';
import 'package:whatbytes_assignment/src/theme/theme_values.dart';

class TaskScreen extends StatefulWidget {
  final String userId;
  const TaskScreen({super.key, required this.userId});

  @override
  State<TaskScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _selectedDueDate;
  Priority _selectedPriority = Priority.medium;

  // Filters for the task list
  Priority? _filterPriority;
  bool _showCompleted = true; // true means show all, false means show incomplete only

  @override
  void initState() {
    super.initState();
    _loadInitialTasks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Helper to load tasks with current filters
  void _loadInitialTasks() {
    context.read<TaskBloc>().add(LoadTasks(
          widget.userId,
        ));
  }

  void _showTaskFormModalSheet({TaskEntity? task}) {
    // Initialize form with task data if editing
    _titleController.text = task?.title ?? '';
    _descController.text = task?.description ?? '';
    _selectedDueDate = task?.dueDate;
    _selectedPriority = task?.priority ?? Priority.medium;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _buildTaskForm(context, setModalState, task);
          },
        );
      },
    ).then((_) {
      // Reset form after closing
      _titleController.clear();
      _descController.clear();
      _selectedDueDate = null;
      _selectedPriority = Priority.medium;
    });
  }

  Widget _buildTaskForm(
    BuildContext context,
    StateSetter setModalState,
    TaskEntity? task,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle indicator
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Form title
            Text(
              task == null ? "Time to Get Creative!" : "Refine Your Task",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 20),

            // Title field
            _buildTitleField(),
            const SizedBox(height: 15),

            // Description field
            _buildDescriptionField(),
            const SizedBox(height: 15),

            // Due date picker
            _buildDatePicker(setModalState),
            const SizedBox(height: 15),

            // Priority selector
            _buildPrioritySelector(setModalState),
            const SizedBox(height: 25),

            // Action buttons
            _buildFormActionButtons(task),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Your Task Title *',
        labelStyle: TextStyle(color: AppColors.blackColor.withOpacity(0.7)),
        hintText: 'e.g., Finish report by Friday',
        prefixIcon: Icon(Icons.edit_outlined, color: AppColors.greyColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.accentColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descController,
      decoration: InputDecoration(
        labelText: 'What\'s it all about?',
        labelStyle: TextStyle(color: AppColors.blackColor.withOpacity(0.7)),
        hintText: 'Add details here...',
        prefixIcon: Icon(
          Icons.description_outlined,
          color: AppColors.greyColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.accentColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.5)),
        ),
      ),
      maxLines: 3,
    );
  }

  Widget _buildDatePicker(StateSetter setModalState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.5)),
      ),
      child: ListTile(
        leading: Icon(Icons.calendar_month, color: AppColors.greyColor),
        title: Text(
          _selectedDueDate == null
              ? 'When\'s the deadline?'
              : 'Due: ${DateFormat('MMM dd, EEEE').format(_selectedDueDate!)}',
          style: const TextStyle(color: AppColors.blackColor),
        ),
        trailing: _selectedDueDate != null
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: AppColors.greyColor.withOpacity(0.8),
                ),
                onPressed: () {
                  setModalState(() {
                    _selectedDueDate = null;
                  });
                },
              )
            : null,
        onTap: () async {
          final picked = await _selectDueDate(context);
          if (picked != null) {
            setModalState(() {
              _selectedDueDate = picked;
            });
          }
        },
      ),
    );
  }

  Future<DateTime?> _selectDueDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.appsTagColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.blackColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Widget _buildPrioritySelector(StateSetter setModalState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<Priority>(
          value: _selectedPriority,
          decoration: InputDecoration(
            labelText: 'How important is it?',
            labelStyle: TextStyle(color: AppColors.blackColor.withOpacity(0.7)),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.star_half, color: AppColors.greyColor),
          ),
          dropdownColor: AppColors.backgroundColor,
          style: const TextStyle(color: AppColors.blackColor),
          items: Priority.values.map((priority) {
            return DropdownMenuItem(
              value: priority,
              child: Text(
                priority.toString().split('.').last,
                style: TextStyle(
                  color: _getPriorityColor(priority),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (Priority? newValue) {
            if (newValue != null) {
              setModalState(() {
                _selectedPriority = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildFormActionButtons(TaskEntity? task) {
    return Row(
      children: [
        // Cancel button
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightGreyColor,
              foregroundColor: AppColors.blackColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 15),

        // Save button
        Expanded(
          child: ElevatedButton(
            onPressed: () => _saveTask(task),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.whiteColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: Text(
              task == null ? "Add Task" : "Save Changes",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void _saveTask(TaskEntity? task) {
    final title = _titleController.text.trim();
    if (title.isEmpty || _selectedDueDate == null) {
      _showValidationError();
      return;
    }

    if (task == null) {
      // Create new task
      final newTask = TaskEntity(
        userId: FirebaseAuth.instance.currentUser!.uid,
        title: title,
        description: _descController.text.trim(),
        dueDate: _selectedDueDate!,
        priority: _selectedPriority,
        isCompleted: false,
      );
      context.read<TaskBloc>().add(CreateTask(newTask));
    } else {
      // Update existing task
      final updatedTask = TaskEntity(
        id: task.id,
        userId: task.userId,
        title: title,
        description: _descController.text.trim(),
        dueDate: _selectedDueDate!,
        priority: _selectedPriority, // Ensure priority is updated
        isCompleted: task.isCompleted,
      );
      context.read<TaskBloc>().add(UpdateTask(updatedTask));
    }
    Navigator.pop(context);
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('A task needs a title and a due date!'),
        backgroundColor: AppColors.warningColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppColors.highPriorityColor;
      case Priority.medium:
        return AppColors.mediumPriorityColor;
      case Priority.low:
        return AppColors.lowPriorityColor;
      default:
        return AppColors.blackColor.withOpacity(0.6);
    }
  }

  Color _getPriorityBgColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppColors.highPriorityColor.withOpacity(0.2);
      case Priority.medium:
        return AppColors.mediumPriorityColor.withOpacity(0.2);
      case Priority.low:
        return AppColors.lowPriorityColor.withOpacity(0.2);
      default:
        return AppColors.beigeColor.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          } else if (state is TaskLoaded || state is TaskLoading) {
            // Re-load tasks if an action (create, update, delete) changes the state
            // This ensures filters are reapplied if needed.
            // This listener will ensure the main screen rebuilds with new data after CUD operations.
            // The actual filtering happens in _buildTaskList
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return _buildLoadingState(textTheme);
          } else if (state is TaskLoaded) {
            return _buildTaskList(state, textTheme);
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          // Default to loading state or an initial state if none matches
          return _buildLoadingState(textTheme);
        },
      ),
    );
  }

  Widget _buildLoadingState(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.appsTagColor.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading your tasks...",
            style: textTheme.bodyLarge?.copyWith(color: AppColors.greyColor),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        // Use StatefulBuilder to manage the internal state of the filter options
        // without rebuilding the entire TaskScreen until filters are applied.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: AppColors.beigeColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    "Filter Your Tasks",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                  ),
                  const SizedBox(height: 20),

                  // Priority filters
                  Text(
                    "Priority:",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor.withOpacity(0.8),
                        ),
                  ),
                  const SizedBox(height: 10),
                  _buildPriorityFilterChips(setModalState),
                  const SizedBox(height: 20),

                  // Status filters
                  Text(
                    "Completion Status:",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor.withOpacity(0.8),
                        ),
                  ),
                  const SizedBox(height: 10),
                  _buildStatusFilterChips(setModalState),
                  const SizedBox(height: 30),

                  // Apply Filters button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // When filters are applied, update the main state and pop
                        setState(() {
                          // The state variables _filterPriority and _showCompleted
                          // are already updated by the individual chip's setState calls
                          // within the StatefulBuilder.
                          // Now, dispatch LoadTasks to re-fetch/re-filter based on these.
                          _loadInitialTasks();
                        });
                        Navigator.pop(context); // Close the modal
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.whiteColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        "Apply Filters",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Clear Filters button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setModalState(() {
                          _filterPriority = null;
                          _showCompleted = true;
                        });
                        setState(() {
                          _loadInitialTasks();
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Clear Filters",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriorityFilterChips(StateSetter setModalState) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        // "All" chip
        FilterChip(
          label: const Text("All"),
          selected: _filterPriority == null,
          selectedColor: AppColors.appsTagColor.withOpacity(0.2),
          checkmarkColor: AppColors.appsTagColor,
          onSelected: (_) {
            setModalState(() {
              _filterPriority = null;
            });
          },
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: _filterPriority == null
                    ? AppColors.appsTagColor
                    : AppColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
          backgroundColor: AppColors.lightGreyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.greyColor.withOpacity(0.5)),
          ),
        ),

        // Priority chips
        ...Priority.values.map((priority) {
          return FilterChip(
            label: Text(priority.toString().split('.').last),
            selected: _filterPriority == priority,
            selectedColor: AppColors.appsTagColor.withOpacity(0.2),
            checkmarkColor: AppColors.appsTagColor,
            onSelected: (_) {
              setModalState(() {
                _filterPriority = priority;
              });
            },
            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _filterPriority == priority
                      ? AppColors.appsTagColor
                      : AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
            backgroundColor: AppColors.lightGreyColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: AppColors.greyColor.withOpacity(0.5)),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatusFilterChips(StateSetter setModalState) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        // Show all tasks chip
        FilterChip(
          label: const Text("Show All"),
          selected: _showCompleted,
          selectedColor: AppColors.appsTagColor.withOpacity(0.2),
          checkmarkColor: AppColors.appsTagColor,
          onSelected: (_) {
            setModalState(() {
              _showCompleted = true;
            });
          },
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: _showCompleted
                    ? AppColors.appsTagColor
                    : AppColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
          backgroundColor: AppColors.lightGreyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.greyColor.withOpacity(0.5)),
          ),
        ),

        // Show incomplete only chip
        FilterChip(
          label: const Text("Show Incomplete"),
          selected: !_showCompleted,
          selectedColor: AppColors.appsTagColor.withOpacity(0.2),
          checkmarkColor: AppColors.appsTagColor,
          onSelected: (_) {
            setModalState(() {
              _showCompleted = false;
            });
          },
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: !_showCompleted
                    ? AppColors.appsTagColor
                    : AppColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
          backgroundColor: AppColors.lightGreyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.greyColor.withOpacity(0.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(TaskEntity task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task completion checkbox
          InkWell(
            onTap: () {
              context.read<TaskBloc>().add(
                    UpdateTask(
                      task.copyWith(isCompleted: !task.isCompleted),
                    ),
                  );
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted ? AppColors.beigeColor : Colors.white,
                border: Border.all(
                  color: task.isCompleted
                      ? AppColors.beigeColor
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.whiteColor,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          // Task details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.greyColor,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.greyColor,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.greyColor,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.greyColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(task.dueDate),
                      style: TextStyle(fontSize: 12, color: AppColors.greyColor),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityBgColor(task.priority),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.priority.toString().split('.').last,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getPriorityColor(task.priority),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Edit and Delete buttons
          Column(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  _showTaskFormModalSheet(task: task);
                },
                tooltip: "Edit Task",
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppColors.errorColor,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, task);
                },
                tooltip: "Delete Task",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(TaskLoaded state, TextTheme textTheme) {
    List<TaskEntity> filteredTasks = state.tasks.where((task) {
      final matchesPriority =
          _filterPriority == null || task.priority == _filterPriority;
      final matchesStatus = _showCompleted || !task.isCompleted;
      return matchesPriority && matchesStatus;
    }).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TaskAppBar(
                  onFilterPressed: _showFilterOptions,
                  onLogoutPressed: () {
                    context.read<AuthBloc>().add(AuthSignOutRequested());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today, ${DateFormat('d MMMM').format(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'My tasks',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F2E41),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (filteredTasks.isEmpty)
                        _buildEmptyStateContent(textTheme)
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // Important for nested scroll views
                          padding: EdgeInsets.zero, // Remove default padding
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return _buildTaskItem(task);
                          },
                        ),
                      const SizedBox(height: 100), // Space for bottom navigation
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _BottomNavBar(
          onAddTaskPressed: _showTaskFormModalSheet,
          onCalendarPressed: () async {
            await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.appsTagColor,
                      onPrimary: AppColors.whiteColor,
                      onSurface: AppColors.blackColor,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.blackColor,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyStateContent(TextTheme textTheme) {
    return Column(
      children: [
        Icon(
          Icons.task_alt,
          size: 100,
          color: AppColors.greyColor.withOpacity(0.7),
        ),
        const SizedBox(height: 20),
        Text(
          _filterPriority != null || !_showCompleted
              ? "No matching tasks found."
              : "You're all caught up! No tasks here.",
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (_filterPriority != null || !_showCompleted)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _filterPriority = null;
                _showCompleted = true;
              });
              _loadInitialTasks(); // Reload tasks after clearing filters
            },
            icon: Icon(Icons.clear, color: AppColors.greyColor),
            label: Text(
              "Clear Filters",
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, TaskEntity task) {
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Task?',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${task.title}"?',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.greyColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: AppColors.greyColor),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTask(task.id!, task.userId));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: AppColors.whiteColor,
              elevation: 3,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Reusable AppBar widget
class _TaskAppBar extends StatelessWidget {
  final VoidCallback onFilterPressed;
  final VoidCallback onLogoutPressed;

  const _TaskAppBar({
    required this.onFilterPressed,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF8A7AE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.grid_view_rounded,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: onFilterPressed,
                    tooltip: "Filter Tasks",
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: onLogoutPressed,
                    tooltip: "Log out",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.7),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Bottom Navigation Bar widget
class _BottomNavBar extends StatelessWidget {
  final VoidCallback onAddTaskPressed;
  final VoidCallback onCalendarPressed;

  const _BottomNavBar({
    required this.onAddTaskPressed,
    required this.onCalendarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.format_list_bulleted_rounded,
                color: Colors.grey[400],
              ),
              onPressed: () {}, // Placeholder for list view action
            ),
            ElevatedButton(
              onPressed: onAddTaskPressed,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                elevation: 0, // Remove default elevation
                backgroundColor: Colors.transparent, // Make button transparent
              ),
              child: Container(
                width: 50, // Increased size for better tap target
                height: 50, // Increased size for better tap target
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF8A7AE0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A5AE0).withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_today_rounded,
                color: Colors.grey[400],
              ),
              onPressed: onCalendarPressed,
            ),
          ],
        ),
      ),
    );
  }
}