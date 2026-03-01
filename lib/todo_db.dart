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
      2: ['ALTER TABLE TodoItem ADD COLUMN priority INTEGER DEFAULT 1'],
    };
    database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      version: 3,
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
        priority: item['priority'],
        deadline: DateTime.parse(item['deadline']),
      );
    }).toList();
  }

  Future<TodoItem> getTodoItemById(int id) async {
    final List<Map<String, dynamic>> rows = await database.query(
      //一覧ページで選択した項目のIDからそのレコードに対応するデータを取得する
      'TodoItem',
      where: 'id = ?',
      whereArgs: [id],
    );
    return TodoItem(
      id: rows[0]['id'],
      title: rows[0]['title'],
      content: rows[0]['content'],
      isCompleted: rows[0]['isCompleted'] == 1,
      priority: rows[0]['priority'],
      deadline: DateTime.parse(rows[0]['deadline']),
    );
  }

  Future<void> insertTodoItem(Map<String, dynamic> formValue) async {
    await database.insert('TodoItem', {
      'title': formValue['title'],
      'content': formValue['content'],
      'isCompleted': 0,
      'priority': formValue['priority'],
      'deadline': formValue['deadline'],
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
    required this.priority,
    required this.deadline,
  });

  final int id;
  final String title;
  final String content;
  final bool isCompleted;
  final int priority;
  final DateTime deadline;
}
