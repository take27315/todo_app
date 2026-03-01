import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod をインポート
// import 'providers.dart';
import 'providers_db.dart';
import 'todo_db.dart';

class TodoDetailPage extends ConsumerWidget {
  const TodoDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ModalRoute.of(context)!.settings.arguments! as int;
    final todoItem = ref.watch(todoDetailProvider(index));
    //final todoNotifier = ref.read(todoProvider.notifier);
    final database = TodoItemDatabase();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todo 詳細'),
      ),
      body: todoItem.when(
        //非同期処理を使うためのメソッド
        data: (todo) {
          // データの取得に成功した場合の処理
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
                        // todoNotifier.replaceTodoItem(index);
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
                ],
              ),
            ),
          );
        },
        error: (err, stack) => const Text('失敗'), // 取得失敗時の処理を記述
        loading: () => const Text('ロード中'), // 取得中の処理を記述
      ),
    );
  }
}
