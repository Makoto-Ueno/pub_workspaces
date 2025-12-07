# Flutter Flavor ガイド - Pub Workspaces

このプロジェクトでは、**Flavor**を使って1つのコードベースから複数のアプリをビルドできます。

## 📋 なぜFlavorを使うのか？

### 従来の方法（各ディレクトリで実行）
```bash
cd apps/demo_app && flutter run
cd apps/shopping_app && flutter run
cd apps/todo_app && flutter run
```

### Flavorを使った方法（ルートから実行）
```bash
flutter run --flavor demo -t lib/main_demo.dart
flutter run --flavor shopping -t lib/main_shopping.dart
flutter run --flavor todo -t lib/main_todo.dart
```

## ✨ Flavorのメリット

1. **1つのプロジェクトで管理**: ルートから全アプリをビルド可能
2. **パッケージIDの分離**: 同じデバイスに複数アプリをインストール可能
3. **ビルド設定の統一**: Android/iOSの設定を一箇所で管理
4. **CI/CD が簡単**: 1つのワークフローで全アプリをビルド

## 🏗️ Flavorの仕組み

### 1. ルートのlib/配下にエントリーポイント

```
lib/
├── flavors.dart          # Flavor設定
├── main_demo.dart        # Demo App起動
├── main_shopping.dart    # Shopping App起動
└── main_todo.dart        # Todo App起動
```

### 2. 各エントリーポイントの役割

**lib/main_shopping.dart** の例:

```dart
import 'package:shopping_app/main.dart' as shopping;
import 'flavors.dart';

void main() {
  // Flavor設定を初期化
  FlavorConfig.initialize(
    flavor: Flavor.shopping,
    name: 'Shopping',
    title: 'Shopping App',
    packageName: 'com.example.pubworkspaces.shopping',
  );

  // Shopping Appを起動
  shopping.runShoppingApp();
}
```

### 3. 各アプリのmain.dartはエクスポート可能に

**apps/shopping_app/lib/main.dart**:

```dart
import 'package:flutter/material.dart';

void main() => runShoppingApp();

// この関数を外部から呼び出し可能にする
void runShoppingApp() {
  runApp(const ShoppingApp());
}
```

### 4. ルートのpubspec.yamlで依存関係を定義

```yaml
dependencies:
  demo_app:
    path: apps/demo_app
  shopping_app:
    path: apps/shopping_app
  todo_app:
    path: apps/todo_app
```

## 🚀 実行コマンド

### 開発時（デバッグモード）

```bash
# Demo App
flutter run --flavor demo -t lib/main_demo.dart

# Shopping App
flutter run --flavor shopping -t lib/main_shopping.dart

# Todo App
flutter run --flavor todo -t lib/main_todo.dart
```

### リリースビルド

**Android APK:**
```bash
flutter build apk --flavor demo -t lib/main_demo.dart
flutter build apk --flavor shopping -t lib/main_shopping.dart
flutter build apk --flavor todo -t lib/main_todo.dart
```

**Android App Bundle (Google Play用):**
```bash
flutter build appbundle --flavor demo -t lib/main_demo.dart
flutter build appbundle --flavor shopping -t lib/main_shopping.dart
flutter build appbundle --flavor todo -t lib/main_todo.dart
```

**iOS:**
```bash
flutter build ios --flavor demo -t lib/main_demo.dart
flutter build ios --flavor shopping -t lib/main_shopping.dart
flutter build ios --flavor todo -t lib/main_todo.dart
```

## 📱 生成されるアプリ

各Flavorは異なるパッケージIDとアプリ名を持ちます:

| Flavor | パッケージID | アプリ名 |
|--------|-------------|---------|
| demo | com.example.pub_workspaces.demo | Demo App |
| shopping | com.example.pub_workspaces.shopping | Shopping App |
| todo | com.example.pub_workspaces.todo | Todo App |

これにより、**同じデバイスに3つのアプリを同時にインストール**できます。

## 🔧 Flavor設定の詳細

### Android設定

`android/app/build.gradle.kts`:

```kotlin
flavorDimensions += "app"
productFlavors {
    create("demo") {
        dimension = "app"
        applicationIdSuffix = ".demo"
        versionNameSuffix = "-demo"
        resValue("string", "app_name", "Demo App")
    }
    // ... 他のFlavor
}
```

### iOS設定（今後追加可能）

Xcodeで各FlavorのSchemeを作成し、Bundle IDを分離できます。

## 💡 よくある質問

### Q: lib/main.dartは不要になる？

**A: いいえ、必要です！**

lib/配下は以下の役割があります:
- `lib/flavors.dart`: Flavor設定の管理
- `lib/main_*.dart`: 各アプリへのエントリーポイント

### Q: apps/配下のコードは？

**A: 各アプリの実装はapps/配下に残します**

- `apps/demo_app/lib/`: Demo Appの実装
- `apps/shopping_app/lib/`: Shopping Appの実装
- `apps/todo_app/lib/`: Todo Appの実装

lib/のエントリーポイントが、これらをimportして起動します。

### Q: 従来の方法も使える？

**A: はい、使えます**

各アプリのディレクトリで個別に実行することも可能:
```bash
cd apps/shopping_app
flutter run
```

ただし、Flavorを使う方が:
- ビルド設定が統一される
- CI/CDが簡単になる
- 1つのコマンドで全アプリをビルド可能

## 🎯 推奨ワークフロー

### 開発時
```bash
# ルートディレクトリから、Flavorで起動
flutter run --flavor shopping -t lib/main_shopping.dart
```

### リリース時
```bash
# 全アプリを一括ビルド（スクリプト化推奨）
flutter build apk --flavor demo -t lib/main_demo.dart
flutter build apk --flavor shopping -t lib/main_shopping.dart
flutter build apk --flavor todo -t lib/main_todo.dart
```

### テスト時
```bash
# 各アプリディレクトリでユニットテスト
cd apps/shopping_app
flutter test
```

## 📝 まとめ

**Pub Workspaces + Flavor** の組み合わせで:

✅ 複数アプリを1つのリポジトリで管理
✅ 共通パッケージを効率的に共有
✅ Flavorでビルドを簡単に切り替え
✅ 同じデバイスに複数アプリをインストール可能
✅ CI/CDでの自動ビルドが容易

**lib/配下は必須です！** Flavorを活用するための重要な役割を果たします。
