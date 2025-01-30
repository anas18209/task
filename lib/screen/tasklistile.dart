import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:taskapp/model/taskmodel.dart';
import 'package:taskapp/providers/task/tasks_provider.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final TextEditingController updateController;
  final WidgetRef ref;

  const TaskListTile({Key? key, required this.task, required this.updateController, required this.ref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskNotifier = ref.read(taskProvider.notifier);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0.4.h),
      child: ListTile(
        title: Text(task.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showUpdateTaskDialog(context, task, taskNotifier)),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => taskNotifier.deleteTask(task.id!)),
          ],
        ),
      ),
    );
  }

  void _showUpdateTaskDialog(BuildContext context, Task task, TaskNotifier taskNotifier) {
    updateController.text = task.name;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Task'),
            content: TextField(controller: updateController, decoration: const InputDecoration(labelText: 'New Task Name')),
            actions: [
              TextButton(
                onPressed: () {
                  if (updateController.text.isNotEmpty) {
                    taskNotifier.updateTask(task.id!, updateController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update'),
              ),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ],
          ),
    );
  }
}
