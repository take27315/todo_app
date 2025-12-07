import 'package:flutter/material.dart';
import 'todo_list.dart';
import 'todo_detail.dart';
import 'todo_add.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(
      child: MyTodoApp(),
    ),);
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