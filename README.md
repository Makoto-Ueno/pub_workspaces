# Flutter Pub Workspaces - 複数アプリサンプル

Flutter Pub Workspacesを使用して、**複数のアプリケーション**で**共通パッケージを共有**するモノレポ構成のサンプルプロジェクトです。

## 📖 Pub Workspacesとは

Pub Workspacesは、複数のDart/Flutterパッケージを1つのリポジトリで管理できるモノレポ機能です。
関連するパッケージやアプリを効率的に開発・管理できます。

## 🏗️ プロジェクト構成

```
pub_workspaces/
├── pubspec.yaml              # ルートワークスペース設定
├── lib/                      # Flavorエントリーポイント（重要！）
│   ├── flavors.dart         # Flavor定義
│   ├── main_demo.dart       # Demo App用エントリーポイント
│   ├── main_shopping.dart   # Shopping App用エントリーポイント
│   └── main_todo.dart       # Todo App用エントリーポイント
├── packages/                 # 共通パッケージディレクトリ
│   ├── core_utils/          # 共通ユーティリティパッケージ
│   │   ├── pubspec.yaml     # resolution: workspace
│   │   └── lib/
│   │       ├── core_utils.dart
│   │       └── src/
│   │           ├── formatter.dart    # 数値・日時のフォーマット
│   │           └── validator.dart    # バリデーション機能
│   └── ui_components/       # UIコンポーネントパッケージ
│       ├── pubspec.yaml     # resolution: workspace
│       └── lib/
│           ├── ui_components.dart
│           └── src/
│               ├── custom_button.dart  # カスタムボタン
│               └── info_card.dart      # 情報カード
└── apps/                     # アプリケーションディレクトリ
    ├── demo_app/            # デモアプリ
    │   ├── pubspec.yaml     # resolution: workspace
    │   └── lib/main.dart    # アプリ本体（runDemoApp()をエクスポート）
    ├── shopping_app/        # ショッピングアプリ
    │   ├── pubspec.yaml     # resolution: workspace
    │   └── lib/main.dart    # アプリ本体（runShoppingApp()をエクスポート）
    └── todo_app/            # TODOアプリ
        ├── pubspec.yaml     # resolution: workspace
        └── lib/main.dart    # アプリ本体（runTodoApp()をエクスポート）
```

## 🎯 含まれるアプリケーション

### 1. **Demo App** (apps/demo_app)
ワークスペース機能のデモンストレーション
- カウンター機能（数値フォーマット表示）
- 現在日時表示
- メールアドレスバリデーション

### 2. **Shopping App** (apps/shopping_app)
ショッピングカート機能を持つアプリ
- 商品一覧表示
- カートへの追加機能
- 合計金額計算（Formatterを使用）
- カート表示ダイアログ

### 3. **Todo App** (apps/todo_app)
タスク管理アプリ
- タスクの追加・編集・削除
- 完了/未完了の管理
- バリデーション機能（Validatorを使用）
- 統計情報表示（InfoCardを使用）

## 📦 共通パッケージ

### core_utils パッケージ
- **Formatter**: 数値のカンマ区切り、日付・時刻のフォーマット
- **Validator**: メールアドレス、電話番号、文字列のバリデーション

### ui_components パッケージ
- **CustomButton**: 再利用可能なカスタムボタン
- **InfoCard**: グラデーション付き情報カード

すべてのアプリがこれらの共通パッケージを使用しています。

## 🚀 アプリの実行方法

### ✨ Flavor を使った実行（推奨）

各アプリを**Flavor**で切り替えて実行できます:

**Demo App:**
```bash
flutter run --flavor demo -t lib/main_demo.dart
```

**Shopping App:**
```bash
flutter run --flavor shopping -t lib/main_shopping.dart
```

**Todo App:**
```bash
flutter run --flavor todo -t lib/main_todo.dart
```

### リリースビルド

**Android APK:**
```bash
# Demo App
flutter build apk --flavor demo -t lib/main_demo.dart

# Shopping App
flutter build apk --flavor shopping -t lib/main_shopping.dart

# Todo App
flutter build apk --flavor todo -t lib/main_todo.dart
```

**iOS:**
```bash
# Demo App
flutter build ios --flavor demo -t lib/main_demo.dart

# Shopping App  
flutter build ios --flavor shopping -t lib/main_shopping.dart

# Todo App
flutter build ios --flavor todo -t lib/main_todo.dart
```

### 従来の方法（各アプリディレクトリで実行）

各アプリのディレクトリに移動して実行することも可能:

```bash
cd apps/demo_app
flutter run

cd apps/shopping_app
flutter run

cd apps/todo_app
flutter run
```

## 🔧 セットアップ手順

### 1. 依存関係のインストール

```bash
flutter pub get
```

ルートディレクトリで一度実行するだけで、**すべてのアプリとパッケージ**の依存関係が自動的に解決されます。

### 2. 個別アプリの実行

各アプリのディレクトリに移動して実行:
```bash
cd apps/shopping_app
flutter run
```

## 🔑 Pub Workspacesの重要なポイント

### Flavorを使ったアプリ切り替え

**なぜルートのlib/が必要？**

Flavorを使う場合、**ルートプロジェクトのlib/ディレクトリが重要**です:

1. **lib/flavors.dart**: Flavor設定を一元管理
2. **lib/main_*.dart**: 各アプリへのエントリーポイント

各エントリーポイントは、対応するアプリをimportして起動:

```dart
// lib/main_shopping.dart
import 'package:shopping_app/main.dart' as shopping;
import 'flavors.dart';

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.shopping,
    name: 'Shopping',
    title: 'Shopping App',
    packageName: 'com.example.pubworkspaces.shopping',
  );
  
  shopping.runShoppingApp();
}
```

この構成により:
- ✅ 1つのプロジェクトで複数アプリを管理
- ✅ `--flavor`と`-t`オプションでアプリを切り替え
- ✅ 各アプリに異なるパッケージ名・アプリ名を設定可能
- ✅ ビルド設定をAndroid/iOSで統一管理

### ルートのpubspec.yaml設定

```yaml
workspace:
  # 共通パッケージ
  - packages/core_utils
  - packages/ui_components
  # アプリケーション
  - apps/demo_app
  - apps/shopping_app
  - apps/todo_app

dependencies:
  # 各アプリへの依存（Flavorで切り替え）
  demo_app:
    path: apps/demo_app
  shopping_app:
    path: apps/shopping_app
  todo_app:
    path: apps/todo_app
```

### 各パッケージ/アプリのpubspec.yaml設定

```yaml
name: shopping_app
resolution: workspace  # 重要: ワークスペースメンバーとして設定

dependencies:
  # 共通パッケージを参照（相対パス）
  core_utils:
    path: ../../packages/core_utils
  ui_components:
    path: ../../packages/ui_components
```

### Android Flavor設定

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
    create("shopping") {
        dimension = "app"
        applicationIdSuffix = ".shopping"
        versionNameSuffix = "-shopping"
        resValue("string", "app_name", "Shopping App")
    }
    create("todo") {
        dimension = "app"
        applicationIdSuffix = ".todo"
        versionNameSuffix = "-todo"
        resValue("string", "app_name", "Todo App")
    }
}
```

これにより、各FlavorごとにパッケージIDとアプリ名が変わります:
- Demo: `com.example.pub_workspaces.demo`
- Shopping: `com.example.pub_workspaces.shopping`
- Todo: `com.example.pub_workspaces.todo`

## 💡 Pub Workspacesのメリット

### ✅ 複数アプリでの共通パッケージ共有
- 3つのアプリすべてが同じ`core_utils`と`ui_components`を使用
- パッケージの変更が**すべてのアプリに即座に反映**
- コードの重複を排除し、一貫性を保持

### ✅ 一元管理
- `flutter pub get`一回で全アプリ・全パッケージの依存関係を解決
- バージョン管理が容易
- リポジトリが1つで済む

### ✅ 開発効率
- パッケージ間の変更が即座に反映（ビルド不要）
- IDEのコード補完やジャンプ機能が正常に動作
- 各パッケージ・アプリを独立してテスト可能

### ✅ スケーラビリティ
- 新しいアプリを簡単に追加可能
- 新しい共通パッケージも簡単に作成可能
- アプリごとに異なるプラットフォーム対応も可能

## ⚠️ 注意点

### 必須設定
- 各パッケージ/アプリに`resolution: workspace`が必須
- ルートのpubspec.yamlにすべてのメンバーを列挙
- 相対パスで依存関係を指定

### ディレクトリ構造
```
apps/     # アプリケーション（実行可能）
packages/ # 共通パッケージ（ライブラリ）
```
この分離により、役割が明確になります。

## 🎯 実用的な活用シーン

### 1. 企業向けアプリ群
- 顧客向けアプリ
- 管理者向けアプリ
- スタッフ向けアプリ
→ 共通のUI・ビジネスロジックを共有

### 2. プラットフォーム別アプリ
- モバイルアプリ
- Webアプリ
- デスクトップアプリ
→ コアロジックを共有しつつ、UIを分離

### 3. White Label製品
- ブランドAアプリ
- ブランドBアプリ
- ブランドCアプリ
→ 機能は共通、テーマだけ変更

### 4. ライブラリ開発
- ライブラリ本体
- サンプルアプリ
- テストアプリ
→ 同じリポジトリで開発とデモを管理

## 📚 参考リンク

- [Dart Workspaces公式ドキュメント](https://dart.dev/go/pub-workspaces)
- [Flutter公式サイト](https://flutter.dev)

