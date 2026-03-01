import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers_db.dart';
import 'todo_db.dart';

class TodoDetailPage extends ConsumerWidget {
  const TodoDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ModalRoute.of(context)!.settings.arguments as int;
    final todoItem = ref.watch(todoDetailProvider(index));
    final database = TodoItemDatabase();

    return Scaffold(
      appBar: AppBar(title: const Text('Todo詳細')),
      body: Center(
        child: todoItem.when(
          data: (todo) {
            return Center(
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
                        child: Text(todo.title),
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
                        child: Text(todo.content),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Text(
                        todo.priority == 0
                            ? '優先度：高'
                            : todo.priority == 1
                            ? '優先度：中'
                            : '優先度：低',
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          database.changeTodoItem(todo.id, todo.isCompleted);
                          ref.invalidate(todoProvider);
                          ref.invalidate(todoDetailProvider);
                          Navigator.of(context).pop();
                        },
                        child: todo.isCompleted
                            ? const Text('未完了にする')
                            : const Text('完了にする'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                        child: const Text('編集する'),
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed('/edit', arguments: todo);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (err, stack) => const Text('失敗'),
          loading: () => const Text('ロード中・・・'),
        ),
      ),
    );
  }
}
