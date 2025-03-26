import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaskFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (taskProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${taskProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => taskProvider.fetchTasks(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No tasks yet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskFormScreen(),
                        ),
                      );
                    },
                    child: const Text('Create Task'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => taskProvider.fetchTasks(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 88),
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return TaskCard(
                  task: task,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskFormScreen(task: task),
                      ),
                    );
                  },
                  onDelete: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    try {
                      await taskProvider.deleteTask(task.id!);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Task deleted successfully')),
                      );
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}