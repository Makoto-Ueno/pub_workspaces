import 'package:demo_app/main.dart' as demo;
import 'flavors.dart';

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.demo,
    name: 'Demo',
    title: 'Pub Workspaces Demo',
    packageName: 'com.example.pubworkspaces.demo',
  );

  demo.runDemoApp();
}
