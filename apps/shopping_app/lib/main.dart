import 'package:flutter/material.dart';
import 'package:core_utils/core_utils.dart';
import 'package:ui_components/ui_components.dart';

void main() => runShoppingApp();

void runShoppingApp() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ShoppingHomePage(),
    );
  }
}

class Product {
  final String name;
  final int price;
  final String description;
  final IconData icon;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.icon,
  });
}

class ShoppingHomePage extends StatefulWidget {
  const ShoppingHomePage({super.key});

  @override
  State<ShoppingHomePage> createState() => _ShoppingHomePageState();
}

class _ShoppingHomePageState extends State<ShoppingHomePage> {
  final List<Product> _products = [
    Product(
      name: 'ノートPC',
      price: 150000,
      description: '高性能なノートパソコン',
      icon: Icons.laptop_mac,
    ),
    Product(
      name: 'スマートフォン',
      price: 98000,
      description: '最新モデル',
      icon: Icons.smartphone,
    ),
    Product(
      name: 'ワイヤレスイヤホン',
      price: 15000,
      description: 'ノイズキャンセリング機能付き',
      icon: Icons.headphones,
    ),
    Product(
      name: 'タブレット',
      price: 65000,
      description: '10インチディスプレイ',
      icon: Icons.tablet_mac,
    ),
  ];

  final Map<Product, int> _cart = {};

  void _addToCart(Product product) {
    setState(() {
      _cart[product] = (_cart[product] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name}をカートに追加しました'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  int get _totalPrice {
    int total = 0;
    _cart.forEach((product, quantity) {
      total += product.price * quantity;
    });
    return total;
  }

  int get _totalItems {
    int total = 0;
    _cart.forEach((_, quantity) {
      total += quantity;
    });
    return total;
  }

  void _showCart() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('ショッピングカート'),
            content: SizedBox(
              width: double.maxFinite,
              child:
                  _cart.isEmpty
                      ? const Text('カートは空です')
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ..._cart.entries.map((entry) {
                            return ListTile(
                              leading: Icon(entry.key.icon),
                              title: Text(entry.key.name),
                              subtitle: Text(
                                '${Formatter.formatNumber(entry.key.price)}円 × ${entry.value}',
                              ),
                              trailing: Text(
                                '${Formatter.formatNumber(entry.key.price * entry.value)}円',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                          const Divider(),
                          ListTile(
                            title: const Text(
                              '合計',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              '${Formatter.formatNumber(_totalPrice)}円',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _cart.clear();
                  });
                  Navigator.pop(context);
                },
                child: const Text('クリア'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('閉じる'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ショッピングアプリ'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _showCart,
              ),
              if (_totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_totalItems',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoCard(
              title: '商品一覧',
              content: '気になる商品をカートに追加してください',
              icon: Icons.shopping_bag,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            ..._products.map((product) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(product.icon, size: 48, color: Colors.blue),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.description,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '¥${Formatter.formatNumber(product.price)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        label: 'カートに追加',
                        onPressed: () => _addToCart(product),
                        backgroundColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
