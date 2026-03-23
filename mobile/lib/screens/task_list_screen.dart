import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await ApiService.getTasks();
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.amber;
      case 'low':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E2E Test Workspace'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _tasks.isEmpty
                  ? const Center(child: Text('No tasks yet'))
                  : RefreshIndicator(
                      onRefresh: _loadTasks,
                      child: ListView.separated(
                        itemCount: _tasks.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 6,
                              backgroundColor: _priorityColor(task.priority),
                            ),
                            title: Text(task.title),
                            subtitle: Text('${task.status} \u00b7 ${task.priority}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.pushNamed(context, '/tasks/${task.id}'),
                          );
                        },
                      ),
                    ),
    );
  }
}
