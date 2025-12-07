import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_item.dart';

final todoProvider = NotifierProvider<TodoListNotifier, List<TodoItem>>(
  () => TodoListNotifier(),
);

final bottomBarProvider = NotifierProvider<BottomBarNotifier, int>(
  () => BottomBarNotifier(),
);

class TodoListNotifier extends Notifier<List<TodoItem>> {
  @override
  List<TodoItem> build() {
    return [
      TodoItem(
        id: 0,
        title: 'Flutter',
        content: 'Flutter を勉強する',
        isCompleted: false,
      ),
      TodoItem(id: 1, title: '買い物', content: '卵を買う', isCompleted: false),
      TodoItem(id: 2, title: '課題', content: '月 3 レポート', isCompleted: false),
    ];
  }

  int getIncompletedItemCount() {
    return state.where((item) => !item.isCompleted).length;
  }

  int getCompletedItemCount() {
    return state.where((item) => item.isCompleted).length;
  }

  void addTodoItem(Map<String, String> formValue) {
    state = [
      ...state,
      TodoItem(
        id: state.length,
        title: formValue['title']!,
        content: formValue['content']!,
        isCompleted: false,
      ),
    ];
  }

  void replaceTodoItem(int index) {
    state = [
      for (final todo in state)
        if (todo.id == index)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo,
    ];
  }
}

class BottomBarNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void changeBottomBarIndex(int index) {
    state = index;
  }
}
