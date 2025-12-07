import 'package:flutter/material.dart';
import 'package:core_utils/core_utils.dart';
import 'package:ui_components/ui_components.dart';

void main() => runTodoApp();

void runTodoApp() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TodoHomePage(),
    );
  }
}

class Todo {
  String title;
  String description;
  bool isCompleted;
  final DateTime createdAt;

  Todo({
    required this.title,
    required this.description,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Todo> _todos = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _addTodo() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (!Validator.isNotEmpty(title)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('タイトルを入力してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!Validator.hasMinLength(title, 3)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('タイトルは3文字以上必要です'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _todos.add(Todo(title: title, description: description));
      _titleController.clear();
      _descriptionController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('タスクを追加しました'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('タスクを削除しました'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _editTodo(int index) {
    final todo = _todos[index];
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('タスクを編集'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: '説明',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _titleController.clear();
                  _descriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () {
                  if (Validator.isNotEmpty(_titleController.text) &&
                      Validator.hasMinLength(_titleController.text, 3)) {
                    setState(() {
                      todo.title = _titleController.text;
                      todo.description = _descriptionController.text;
                    });
                    _titleController.clear();
                    _descriptionController.clear();
                    Navigator.pop(context);
                  }
                },
                child: const Text('保存'),
              ),
            ],
          ),
    );
  }

  int get _completedCount => _todos.where((todo) => todo.isCompleted).length;
  int get _pendingCount => _todos.where((todo) => !todo.isCompleted).length;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TODOアプリ'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        title: '完了',
                        content: '${Formatter.formatNumber(_completedCount)}件',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: InfoCard(
                        title: '未完了',
                        content: '${Formatter.formatNumber(_pendingCount)}件',
                        icon: Icons.pending,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'タイトル',
                            border: OutlineInputBorder(),
                            hintText: '例: 買い物に行く',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: '説明（オプション）',
                            border: OutlineInputBorder(),
                            hintText: '詳細を入力...',
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          label: 'タスクを追加',
                          onPressed: _addTodo,
                          backgroundColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child:
                _todos.isEmpty
                    ? const Center(
                      child: Text(
                        'タスクがありません\n上のフォームから追加してください',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _todos.length,
                      itemBuilder: (context, index) {
                        final todo = _todos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: todo.isCompleted,
                              onChanged: (_) => _toggleTodo(index),
                            ),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                decoration:
                                    todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (todo.description.isNotEmpty)
                                  Text(todo.description),
                                const SizedBox(height: 4),
                                Text(
                                  '作成: ${Formatter.formatDate(todo.createdAt)} ${Formatter.formatTime(todo.createdAt)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _editTodo(index),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteTodo(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
