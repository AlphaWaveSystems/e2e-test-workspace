import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';
import 'screens/task_detail_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E2E Test Workspace',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TaskListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/tasks/') ?? false) {
          final id = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => TaskDetailScreen(taskId: id),
          );
        }
        return null;
      },
    );
  }
}
