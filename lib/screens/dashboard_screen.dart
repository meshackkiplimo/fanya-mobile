import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/stats_card.dart';
import '../widgets/tasks_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
        title: const Text('Dashboard'),
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

          final stats = taskProvider.stats;
          if (stats == null) {
            return const Center(child: Text('No data available'));
          }

          return RefreshIndicator(
            onRefresh: () => taskProvider.fetchTasks(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Total Tasks',
                        value: stats['totalTasks'].toString(),
                        icon: Icons.task,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Tasks This Month',
                        value: stats['tasksThisMonth'].toString(),
                        trend: {
                          'value': stats['monthlyChange'],
                          'isUpward': stats['monthlyChange'] > 0,
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Last 30 Days',
                        value: stats['tasksLast30Days'].toString(),
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TasksChart(
                  tasks: taskProvider.tasks,
                  title: 'Daily Task Completion',
                  isDailyChart: true,
                ),
                const SizedBox(height: 24),
                TasksChart(
                  tasks: taskProvider.tasks,
                  title: 'Monthly Task Completion',
                  isDailyChart: false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}