import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // 追加
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart'; // 追加
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';// 追加
import 'todo_list.dart';
import 'todo_detail.dart';
import 'todo_add.dart';
import 'todo_db.dart'; 
Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 if (kIsWeb) {// 追加
   databaseFactory = databaseFactoryFfiWeb;// 追加
 }// 追加
 await TodoItemDatabase().initDatabase(); // データベースの初期化
 runApp(const ProviderScope(child: MyTodoApp()));
}


class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TodoListPage(),
        '/add': (context) => const TodoAddPage(),
        '/detail': (context) => const TodoDetailPage(),
      },
    );
  }
}