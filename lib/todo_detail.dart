import 'package:flutter/material.dart';
import 'todo_item.dart';

class TodoDetailArguments {
  TodoDetailArguments(this.index, this.todoItem, this.replaceTodoItem);

  final int index;
  final TodoItem todoItem;
  final Function(int) replaceTodoItem;
}

class TodoDetailPage extends StatelessWidget {
  const TodoDetailPage({
    super.key,
    required this.index,
    required this.todoItem,
    required this.replaceTodoItem,
  });

  final int index;
  final TodoItem todoItem;
  final Function(int) replaceTodoItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todo 詳細'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 4),
                child: const Text('タイトル'),
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 32),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  width: 300,
                  child: Text(todoItem.title),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 8),
                child: const Text('内容'),
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 32),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 300,
                  height: 200,
                  child: Text(todoItem.content),
                ),
              ),
              SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    replaceTodoItem(index);
                    Navigator.of(context).pop();
                  },
                  child: todoItem.isCompleted
                    ? const Text('未完了にする')
                    : const Text('完了にする'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}