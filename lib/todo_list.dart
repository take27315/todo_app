import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo_db.dart';
import 'providers_db.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = TodoItemDatabase();
    final todoItems = ref.watch(todoProvider);
    final bottomBarIndex = ref.watch(bottomBarProvider);
    final bottomBarIndexNotifier = ref.read(bottomBarProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<int>>(
          future: Future.wait([
            database.getTodoItemsCount(),
            database.getCompletedTodoItemsCount(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('loading...');
            }
            if (snapshot.hasError) {
              return Text('Errors:${snapshot.error}');
            }
            final sum = snapshot.data![0];
            final completedItemLength = snapshot.data![1];
            return Text('ToDo 一覧（完了済み $completedItemLength/$sum)');
          },
        ),
      ),
      body: Center(
        child: todoItems.when(
          data: (todos) {
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                if (!todo.isCompleted && bottomBarIndex == 0 ||
                    todo.isCompleted && bottomBarIndex == 1) {
                  return Card(
                    child: ListTile(
                      title: Text(todo.title),
                      trailing: Checkbox(
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        onChanged: (_) {
                          database.changeTodoItem(todo.id, todo.isCompleted);
                          ref.invalidate(todoProvider);
                          ref.invalidate(todoDetailProvider);
                        },
                        value: todo.isCompleted,
                      ),
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed('/detail', arguments: todo.id);
                      },
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          },
          error: (err, stack) => const Text('エラーが発生しました'),
          loading: () => const Text('ロード中'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.unpublished), label: '未完了'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: '完了'),
        ],
        onTap: bottomBarIndexNotifier.changeBottomBarIndex,
        currentIndex: bottomBarIndex,
      ),
    );
  }
}
