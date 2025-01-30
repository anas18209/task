import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:taskapp/model/taskmodel.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'tasks';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    return await db.insert(tableName, task.toMap());
  }

  Future<List<Task>> searchTasks(String query) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: "name LIKE ?",
      whereArgs: ['%$query%'], // Search tasks containing the query
    );
    return List.generate(maps.length, (i) {
      return Task(id: maps[i]['id'], name: maps[i]['name']);
    });
  }

  Future<List<Task>> getTasks() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Task(id: maps[i]['id'], name: maps[i]['name']);
    });
  }

  Future<int> updateTask(Task task) async {
    Database db = await instance.database;

    return await db.update(tableName, task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
