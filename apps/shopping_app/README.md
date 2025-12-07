# Shopping App

商品を閲覧してカートに追加できるショッピングアプリです。

## 機能

- **商品一覧**: 電子機器の商品を表示
- **カート追加**: 商品をカートに追加
- **カート表示**: 追加した商品と合計金額を表示
- **価格表示**: 数値をカンマ区切りでフォーマット

## 使用している共通パッケージ

- `core_utils`: Formatter（価格のフォーマット）
- `ui_components`: CustomButton, InfoCard

## 実行方法

```bash
cd apps/shopping_app
flutter run
```

## 特徴

商品の価格計算にFormatterを活用し、見やすい表示を実現しています。
共通UIコンポーネントで統一感のあるデザインを維持しています。
