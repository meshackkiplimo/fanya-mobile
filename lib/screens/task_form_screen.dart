import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_form.dart';

class TaskFormScreen extends StatelessWidget {
  final Task? task;

  const TaskFormScreen({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task != null ? 'Edit Task' : 'Create Task'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return TaskForm(
            initialData: task,
            onSubmit: (Task newTask) async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                if (task != null) {
                  await taskProvider.updateTask(task!.id!, newTask);
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Task updated successfully')),
                  );
                } else {
                  await taskProvider.createTask(newTask);
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Task created successfully')),
                  );
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}