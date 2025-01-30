import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskapp/model/taskmodel.dart';
import 'package:taskapp/screen/databasehelper.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    state = await DatabaseHelper.instance.getTasks();
  }

  Future<void> addTask(String name) async {
    final task = Task(name: name);
    int id = await DatabaseHelper.instance.insertTask(task);
    state = [...state, Task(id: id, name: name)];
  }

  Future<void> updateTask(int id, String newName) async {
    final updatedTask = Task(id: id, name: newName);
    await DatabaseHelper.instance.updateTask(updatedTask);
    state = state.map((task) => task.id == id ? updatedTask : task).toList();
  }

  Future<void> searchTasks(String query) async {
    if (query.isEmpty) {
      _loadTasks();
    } else {
      List<Task> filteredTasks = await DatabaseHelper.instance.searchTasks(query);
      state = filteredTasks;
    }
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    state = state.where((task) => task?.id != id).toList();
  }
}

extension on Object? {
  get id => null;
}

// Provider to manage tasks
final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});
final checkboxProvider = StateProvider<bool>((ref) => false);
