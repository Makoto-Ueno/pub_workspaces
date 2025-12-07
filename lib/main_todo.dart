import 'package:todo_app/main.dart' as todo;
import 'flavors.dart';

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.todo,
    name: 'Todo',
    title: 'Todo App',
    packageName: 'com.example.pubworkspaces.todo',
  );

  todo.runTodoApp();
}
