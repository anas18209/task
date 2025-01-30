import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:taskapp/providers/theme/theme_provider.dart';
import 'package:taskapp/screen/searchbar.dart';
import 'package:taskapp/screen/tasklistile.dart';
import '../providers/task/tasks_provider.dart';

class TaskApp extends ConsumerStatefulWidget {
  const TaskApp({Key? key}) : super(key: key);

  @override
  _TaskAppState createState() => _TaskAppState();
}

class _TaskAppState extends ConsumerState<TaskApp> {
  final TextEditingController _updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: const Color(0xff0C0C0D),
      appBar: AppBar(
        actions: [
          Expanded(child: SwitchListTile(title: const Text("Task App"), value: isDarkMode, onChanged: (value) => themeNotifier.toggleTheme())),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          children: [
            SearchBarWidget(),
            SizedBox(height: 1.h),
            Expanded(
              child:
                  tasks.isEmpty
                      ? Center(child: Text("No data found", style: TextStyle(fontSize: 18.sp, color: Colors.white)))
                      : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return TaskListTile(task: task, updateController: _updateController, ref: ref);
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 1.h),
        child: FloatingActionButton(onPressed: () => _showAddTaskDialog(context), child: const Icon(Icons.add)),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add Task', style: TextStyle(fontSize: 20.sp)),
            content: TextField(controller: _updateController, decoration: const InputDecoration(labelText: 'New Task Name')),
            actions: [
              TextButton(
                onPressed: () {
                  if (_updateController.text.isNotEmpty) {
                    ref.read(taskProvider.notifier).addTask(_updateController.text);
                    _updateController.clear();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Task'),
              ),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ],
          ),
    );
  }
}
