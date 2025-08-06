// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatbytes_assignment/features/tasks/domain/entities/task_entity.dart';
import 'package:whatbytes_assignment/features/tasks/presentation/blocs/task_bloc.dart';
import 'package:whatbytes_assignment/features/tasks/presentation/blocs/task_event.dart';
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

  Priority? _filterPriority;
  bool _showCompleted = true;
  // Dummy data for tasks
  // final List<Map<String, dynamic>> todayTasks = [
  //   {'title': 'Schedule dentist appointment', 'tags': ['Personal']},
  //   {'title': 'Prepare Team Meeting', 'tags': ['Apps', 'Work']},
  // ];

  // final List<Map<String, dynamic>> tomorrowTasks = [
  //   {'title': 'Call Charlotte', 'tags': ['Personal']},
  //   {'title': 'Submit exercise 3.1', 'tags': ['CS', 'Math']},
  //   {'title': 'Prepare A/B Test', 'tags': ['Apps', 'Work']},
  // ];

  // final List<Map<String, dynamic>> thisWeekTasks = [
  //   {'title': 'Submit exercise 3.2', 'tags': ['CS', 'Math']},
  //   {'title': 'Water plants', 'tags': ['Personal']},
  // ];
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
    void _loadInitialTasks() {
    context.read<TaskBloc>().add(LoadTasks(widget.userId));
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background purple wave (top-left corner)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main content scrollable view
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180.0,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6A5AE0), Color(0xFF8A7AE0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.grid_view_rounded, color: Colors.white),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.more_horiz_rounded, color: Colors.white),
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
                                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.search, color: Colors.grey),
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
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today, 1 May',
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

                      // Today's tasks
                      _buildTaskCategory('Today', todayTasks),
                      const SizedBox(height: 20),

                      // Tomorrow's tasks
                      _buildTaskCategory('Tomorrow', tomorrowTasks),
                      const SizedBox(height: 20),

                      // This week's tasks
                      _buildTaskCategory('This week', thisWeekTasks),
                      const SizedBox(height: 100), // Space for bottom navigation
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom Navigation Bar
          Align(
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
                    icon: Icon(Icons.format_list_bulleted_rounded, color: Colors.grey[400]),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    onPressed: () {  },
                    child: Container(
                      width: 60,
                      height: 60,
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
                    icon: Icon(Icons.calendar_today_rounded, color: Colors.grey[400]),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCategory(String title, List<Map<String, dynamic>> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F2E41),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: tasks.map((task) => _buildTaskItem(task)).toList(),
        ),
      ],
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
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
        children: [
          // Task completion circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.circle_outlined, size: 16, color: Colors.transparent), // Placeholder for unchecked
            ),
          ),
          const SizedBox(width: 16),
          // Task title
          Expanded(
            child: Text(
              task['title'],
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2F2E41),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Tags
          Row(
            children: task['tags'].map<Widget>((tag) {
              Color tagColor;
              switch (tag) {
                case 'Personal':
                  tagColor = Colors.orange[100]!;
                  break;
                case 'Apps':
                  tagColor = Colors.purple[100]!;
                  break;
                case 'Work':
                  tagColor = Colors.orange[100]!; // Or a different color if needed
                  break;
                case 'CS':
                  tagColor = Colors.blue[100]!;
                  break;
                case 'Math':
                  tagColor = Colors.green[100]!;
                  break;
                default:
                  tagColor = Colors.grey[200]!;
              }
              return Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    color: tag == 'Personal' || tag == 'Work' ? Colors.orange[800] : (tag == 'Apps' ? Colors.purple[800] : (tag == 'CS' ? Colors.blue[800] : Colors.green[800])),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}