import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'providers_db.dart';
import 'todo_db.dart';

class TodoAddPage extends ConsumerStatefulWidget {
  const TodoAddPage({super.key});

  @override
  ConsumerState<TodoAddPage> createState() => _TodoAddPageState();
}

class _TodoAddPageState extends ConsumerState<TodoAddPage> {
  final database = TodoItemDatabase();
  final formKey = GlobalKey<FormState>();
  final titleFormKey = GlobalKey<FormFieldState<String>>();
  final contentFormKey = GlobalKey<FormFieldState<String>>();
  int selectedPriority = 0;
  final radioLabels = ['高', '中', '低'];
  final deadlineController = TextEditingController();
  Map<String, dynamic> formValue = {};

  @override
  void dispose() {
    deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo 追加')),
      body: Form(
        key: formKey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.all(4),
                width: 300,
                child: TextFormField(
                  key: titleFormKey,
                  decoration: const InputDecoration(labelText: 'タイトル'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'タイトルを入力してください。';
                    } else if (value.length > 30) {
                      return 'タイトルは30文字以内で入力してください。';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.all(4),
                width: 300,
                height: 200,
                child: TextFormField(
                  key: contentFormKey,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '内容',
                    alignLabelWithHint: true,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 8,
                  validator: (value) {
                    return value == null || value.isEmpty
                        ? '内容を入力してください。'
                        : null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (final radioButtonValue in [0, 1, 2])
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: radioButtonValue,
                            groupValue: selectedPriority,
                            onChanged: (value) {
                              setState(() {
                                selectedPriority = value ?? 0;
                              });
                            },
                          ),
                          Text(radioLabels[radioButtonValue]),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.all(4),
                width: 300,
                child: TextFormField(
                  controller: deadlineController,
                  decoration: const InputDecoration(labelText: 'Deadline'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      deadlineController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(selectedDate);
                    }
                  },
                  validator: (value) {
                    return value == null || value.isEmpty
                        ? '期限を決めてください。'
                        : null;
                  },
                ),
              ),
              SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formValue['title'] =
                          titleFormKey.currentState?.value ?? '';
                      formValue['content'] =
                          contentFormKey.currentState?.value ?? '';
                      formValue['priority'] = selectedPriority;
                      formValue['deadline'] = deadlineController.text;
                      database.insertTodoItem(formValue);
                      ref.invalidate(todoProvider);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Todo を追加'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
