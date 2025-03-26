import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TasksChart extends StatelessWidget {
  final List<Task> tasks;
  final String title;
  final bool isDailyChart;

  const TasksChart({
    Key? key,
    required this.tasks,
    required this.title,
    this.isDailyChart = true,
  }) : super(key: key);

  List<FlSpot> _processData() {
    final Map<DateTime, int> tasksByDate = {};
    
    // Group tasks by date
    for (var task in tasks) {
      final date = DateTime.parse(task.date);
      final key = isDailyChart
          ? DateTime(date.year, date.month, date.day)
          : DateTime(date.year, date.month, 1);
      
      tasksByDate[key] = (tasksByDate[key] ?? 0) + 1;
    }

    // Sort dates and create spots
    final sortedDates = tasksByDate.keys.toList()..sort();
    final spots = <FlSpot>[];
    
    for (var i = 0; i < sortedDates.length; i++) {
      spots.add(FlSpot(
        i.toDouble(),
        tasksByDate[sortedDates[i]]!.toDouble(),
      ));
    }

    return spots;
  }

  List<String> _getLabels() {
    final Map<DateTime, int> tasksByDate = {};
    for (var task in tasks) {
      final date = DateTime.parse(task.date);
      final key = isDailyChart
          ? DateTime(date.year, date.month, date.day)
          : DateTime(date.year, date.month, 1);
      tasksByDate[key] = (tasksByDate[key] ?? 0) + 1;
    }

    final sortedDates = tasksByDate.keys.toList()..sort();
    return sortedDates.map((date) {
      return isDailyChart
          ? DateFormat('MMM dd').format(date)
          : DateFormat('MMM yyyy').format(date);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final spots = _processData();
    final labels = _getLabels();

    if (spots.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No data available'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                labels[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 2,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}