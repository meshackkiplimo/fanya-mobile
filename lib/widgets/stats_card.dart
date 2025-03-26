import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Map<String, dynamic>? trend;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    this.icon,
    this.trend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    color: Colors.grey[400],
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (trend != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    trend!['isUpward'] ? Icons.arrow_upward : Icons.arrow_downward,
                    color: trend!['isUpward'] ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${trend!['value'].abs().toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: trend!['isUpward'] ? Colors.green : Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}