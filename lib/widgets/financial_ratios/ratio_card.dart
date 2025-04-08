import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RatioCard extends StatelessWidget {
  final String title;
  final double value;
  final String? unit;
  final String description;
  final Color? color;

  const RatioCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    required this.description,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedValue = value.toStringAsFixed(2);
    
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$formattedValue${unit ?? ''}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: color ?? theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: charts.BarChart(
                _createChartData(value),
                animate: true,
                domainAxis: const charts.OrdinalAxisSpec(
                  renderSpec: charts.NoneRenderSpec(),
                ),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  renderSpec: charts.NoneRenderSpec(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<charts.Series<RatioData, String>> _createChartData(double value) {
    final data = [
      RatioData('Value', value),
      RatioData('Target', 1.0), // Reference line
    ];

    return [
      charts.Series<RatioData, String>(
        id: 'Ratio',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
          Colors.blue.shade300,
        ),
        domainFn: (RatioData ratio, _) => ratio.category,
        measureFn: (RatioData ratio, _) => ratio.value,
        data: data,
      )
    ];
  }
}

class RatioData {
  final String category;
  final double value;

  RatioData(this.category, this.value);
}