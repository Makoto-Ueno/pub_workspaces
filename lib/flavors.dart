enum Flavor { demo, shopping, todo }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String title;
  final String packageName;

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.title,
    required this.packageName,
  });

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    return _instance ??
        FlavorConfig._internal(
          flavor: Flavor.demo,
          name: 'Demo',
          title: 'Pub Workspaces Demo',
          packageName: 'com.example.pubworkspaces.demo',
        );
  }

  static void initialize({
    required Flavor flavor,
    required String name,
    required String title,
    required String packageName,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      name: name,
      title: title,
      packageName: packageName,
    );
  }

  bool get isDemo => flavor == Flavor.demo;
  bool get isShopping => flavor == Flavor.shopping;
  bool get isTodo => flavor == Flavor.todo;
}
