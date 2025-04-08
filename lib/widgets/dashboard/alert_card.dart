import 'package:flutter/material.dart';

enum AlertType { info, warning, error }

class AlertCard extends StatelessWidget {
  final String title;
  final String message;
  final AlertType alertType;

  const AlertCard({
    super.key,
    required this.title,
    required this.message,
    required this.alertType,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (alertType) {
      case AlertType.info:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        icon = Icons.info_outline;
        break;
      case AlertType.warning:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        icon = Icons.warning_amber_outlined;
        break;
      case AlertType.error:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        icon = Icons.error_outline;
        break;
    }

    return Card(
      color: backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: textColor,
              iconSize: 20,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}