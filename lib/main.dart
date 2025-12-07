import 'package:flutter/material.dart';
import 'todo_list.dart';
import 'todo_detail.dart';
import 'todo_add.dart';

void main() {
  runApp(const MyTodoApp());
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
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as TodoDetailArguments;
          return MaterialPageRoute(
            builder: (context) {
              return TodoDetailPage(
                index: args.index,
                todoItem: args.todoItem,
                replaceTodoItem: args.replaceTodoItem,
              );
            },
          );
        } else {
          return MaterialPageRoute(
            builder: (context) {
              return const TodoListPage();
            },
          );
        }
      },
    );
  }
}