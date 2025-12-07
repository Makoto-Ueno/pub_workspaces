import 'package:flutter/material.dart';

void main() {
  runApp(const AppLauncher());
}

class AppLauncher extends StatelessWidget {
  const AppLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Launcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LauncherPage(),
    );
  }
}

class LauncherPage extends StatelessWidget {
  const LauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pub Workspaces - アプリランチャー'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.workspace_premium,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24),
              const Text(
                'Flutter Pub Workspaces',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                '複数アプリで共通パッケージを共有',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              const Text(
                '以下のアプリが利用可能です:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildAppCard(
                icon: Icons.science,
                title: 'Demo App',
                description: 'ワークスペース機能のデモ',
                color: Colors.deepPurple,
                command: 'cd apps/demo_app && flutter run',
              ),
              const SizedBox(height: 16),
              _buildAppCard(
                icon: Icons.shopping_cart,
                title: 'Shopping App',
                description: 'ショッピングカート機能',
                color: Colors.blue,
                command: 'cd apps/shopping_app && flutter run',
              ),
              const SizedBox(height: 16),
              _buildAppCard(
                icon: Icons.check_circle,
                title: 'Todo App',
                description: 'タスク管理アプリ',
                color: Colors.green,
                command: 'cd apps/todo_app && flutter run',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required String command,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: color),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              command,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
