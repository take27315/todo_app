import 'package:flutter/material.dart';
import 'todo_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod をインポート
import 'providers.dart';

class TodoDetailPage extends ConsumerWidget {
  const TodoDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ModalRoute.of(context)!.settings.arguments! as int;
    final todoItems = ref.read(todoProvider);
    final todoNotifier = ref.read(todoProvider.notifier);
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
                  child: Text(todoItems[index].title),
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
                  child: Text(todoItems[index].content),
                ),
              ),
              SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    todoNotifier.replaceTodoItem(index);
                    Navigator.of(context).pop();
                  },
                  child: todoItems[index].isCompleted
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
