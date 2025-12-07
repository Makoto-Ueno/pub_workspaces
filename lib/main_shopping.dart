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
