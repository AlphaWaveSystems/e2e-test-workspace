import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  Task? _task;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    try {
      final task = await ApiService.getTask(widget.taskId);
      setState(() {
        _task = task;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_task?.title ?? 'Task'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _task == null
              ? const Center(child: Text('Task not found'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_task!.title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(_task!.description, style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Chip(label: Text(_task!.status)),
                          const SizedBox(width: 8),
                          Chip(label: Text(_task!.priority)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Created: ${_task!.createdAt}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
    );
  }
}
