import 'package:flutter/material.dart';
import 'package:core_utils/core_utils.dart';
import 'package:ui_components/ui_components.dart';

void main() => runDemoApp();

void runDemoApp() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pub Workspaces Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pub Workspaces Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _emailController = TextEditingController();
  String _emailValidationMessage = '';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _validateEmail() {
    setState(() {
      final email = _emailController.text;
      if (Validator.isValidEmail(email)) {
        _emailValidationMessage = '✓ 有効なメールアドレスです';
      } else {
        _emailValidationMessage = '✗ 無効なメールアドレスです';
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // core_utilsパッケージのFormatterを使用
            InfoCard(
              title: 'カウンター',
              content: 'ボタンを押した回数: ${Formatter.formatNumber(_counter)}回',
              icon: Icons.touch_app,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // 現在の日時を表示
            InfoCard(
              title: '現在の日時',
              content:
                  '${Formatter.formatDate(DateTime.now())} ${Formatter.formatTime(DateTime.now())}',
              icon: Icons.access_time,
              color: Colors.green,
            ),
            const SizedBox(height: 16),

            // メールアドレスのバリデーション
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'メールアドレス検証',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'メールアドレス',
                        border: OutlineInputBorder(),
                        hintText: 'example@email.com',
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomButton(
                      label: '検証',
                      onPressed: _validateEmail,
                      backgroundColor: Colors.deepPurple,
                    ),
                    if (_emailValidationMessage.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _emailValidationMessage,
                        style: TextStyle(
                          color:
                              _emailValidationMessage.contains('✓')
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ui_componentsパッケージのCustomButtonを使用
            CustomButton(
              label: 'カウンターを増やす (+1)',
              onPressed: _incrementCounter,
              backgroundColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
