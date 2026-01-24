import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoItemDatabase {
  TodoItemDatabase._internal();
  static final TodoItemDatabase _instance = TodoItemDatabase._internal();
  factory TodoItemDatabase() => _instance;

  late final Database database;

  Future<Database> initDatabase() async {
    const scripts = {
      1: [
        'CREATE TABLE TodoItem(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, isCompleted INTEGER);',
      ],
    };
    database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) async {
        for (var i = oldVersion + 1; i <= newVersion; i++) {
          final queries = scripts[i] ?? [];
          for (final query in queries) {
            await db.execute(query);
          }
        }
      },
    );
    return database;
  }

  Future<List<TodoItem>> getTodoItems() async {
    final List<Map<String, dynamic>> rows = await database.query('TodoItem');
    return rows.map((item) {
      return TodoItem(
        id: item['id'],
        title: item['title'],
        content: item['content'],
        isCompleted: item['isCompleted'] == 1,
      );
    }).toList();
  }

  Future<void> insertTodoItem(Map<String, String> formValue) async {
    await database.insert('TodoItem', {
      'title': formValue['title'],
      'content': formValue['content'],
      'isCompleted': 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> changeTodoItem(int id, bool isCompleted) async {
    await database.update(
      'TodoItem',
      {'isCompleted': isCompleted ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getTodoItemsCount() async {
    final todoItems = await getTodoItems();
    return todoItems.length;
  }

  Future<int> getCompletedTodoItemsCount() async {
    final todoItems = await getTodoItems();
    return todoItems.where((item) => item.isCompleted).length;
  }
}

class TodoItem {
  TodoItem({
    required this.id,
    required this.title,
    required this.content,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final String content;
  final bool isCompleted;
}
