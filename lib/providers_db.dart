import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_db.dart';

final todoProvider = FutureProvider<List<TodoItem>>(
  (ref) => TodoItemDatabase().getTodoItems(),
);

final bottomBarProvider = NotifierProvider<BottomBarNotifier, int>(
  () => BottomBarNotifier(),
);

// 一覧ページからidを用いて取得してきたTodoを管理するProvider
// .family・・・外部のパラメータを扱うことができる。
// .family<A, B>: A・・・最終的に返すデータ型
//                B・・・外部から受け取る引数の型
final todoDetailProvider = FutureProvider.family<TodoItem, int>((ref, id) {
  return TodoItemDatabase().getTodoItemById(id);
});

class BottomBarNotifier extends Notifier<int> {
  BottomBarNotifier();

  @override
  int build() {
    return 0;
  }

  void changeBottomBarIndex(int index) {
    state = index;
  }
}
