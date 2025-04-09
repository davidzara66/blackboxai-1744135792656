import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:financial_manager/services/database_service.dart';
import 'package:financial_manager/services/export_service.dart';
import 'package:financial_manager/models/sale_purchase_model.dart';
import 'package:flutter_charts/flutter_charts.dart';

class FinancialReportsScreen extends StatelessWidget {
  const FinancialReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.of(context).translate('reports')),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<SalePurchase>>(
                stream: Provider.of<DatabaseService>(context).getSalesPurchases(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 300,
                      padding: EdgeInsets.all(8),
                      child: Chart(
                        data: _prepareChartData(snapshot.data!),
                        behaviors: [
                          LegendBehavior(
                            position: LegendPosition.top,
                            textStyle: TextStyle(fontSize: 12),
                          ),
                          ChartTitleBehavior(
                            title: 'Sales vs Purchases (Last 30 Days)',
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          XAxisTitleBehavior(title: 'Date'),
                          YAxisTitleBehavior(title: 'Amount (\$)'),
                        ],
                        xAxis: DateTimeAxis(
                          tickInterval: 5,
                          tickLabelStyle: TextStyle(fontSize: 10),
                        ),
                        yAxis: LinearAxis(
                          tickLabelStyle: TextStyle(fontSize: 10),
                        ),
                        series: [
                          BarSeries(
                            id: 'sales',
                            color: Colors.green[400]!,
                            displayName: 'Sales',
                          ),
                          BarSeries(
                            id: 'purchases',
                            color: Colors.red[400]!,
                            displayName: 'Purchases',
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _exportReport(context, format: 'pdf'),
                  child: const Text('Export PDF'),
                ),
                ElevatedButton(
                  onPressed: () => _exportReport(context, format: 'excel'),
                  child: const Text('Export Excel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ChartData _prepareChartData(List<SalePurchase> transactions) {
    final chartData = ChartData();
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    final recentTransactions = transactions.where((t) => t.date.isAfter(thirtyDaysAgo));
    
    // Group transactions by day
    final dailyData = <DateTime, Map<String, double>>{};
    
    for (final t in recentTransactions) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);
      dailyData.putIfAbsent(date, () => {'sales': 0, 'purchases': 0});
      
      if (t.type == TransactionType.sale) {
        dailyData[date]!['sales'] = dailyData[date]!['sales']! + t.amount;
      } else {
        dailyData[date]!['purchases'] = dailyData[date]!['purchases']! + t.amount;
      }
    }
    
    // Convert to ChartDatum format
    dailyData.forEach((date, values) {
      chartData.addAll([
        ChartDatum(
          x: date,
          y: values['sales']!,
          seriesId: 'sales'
        ),
        ChartDatum(
          x: date,
          y: values['purchases']!,
          seriesId: 'purchases'
        )
      ]);
    });
    
    return chartData;
  }

  Future<void> _exportReport(BuildContext context, {required String format}) async {
    final database = Provider.of<DatabaseService>(context, listen: false);
    final transactions = await database.getSalesPurchases().first;
    final messenger = ScaffoldMessenger.of(context);
    
    try {
      if (format == 'pdf') {
        final pdf = await ExportService.generatePdfReport(transactions);
        final output = await getTemporaryDirectory();
        final fileName = 'financial_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${output.path}/$fileName');
        await file.writeAsBytes(await pdf.save());
        
        messenger.showSnackBar(
          SnackBar(
            content: Text('PDF saved as $fileName'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                if (await canLaunch(file.path)) {
                  await launch(file.path);
                } else {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Could not open file')),
                  );
                }
              },
            ),
          ),
        );
      } else {
        final excel = ExportService.generateExcelReport(transactions);
        final output = await getTemporaryDirectory();
        final fileName = 'financial_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        final file = File('${output.path}/$fileName');
        await file.writeAsBytes(excel.encode()!);
        
        messenger.showSnackBar(
          SnackBar(
            content: Text('Excel saved as $fileName'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                if (await canLaunch(file.path)) {
                  await launch(file.path);
                } else {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Could not open file')),
                  );
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: ${e.toString()}')),
      );
    }
  }
}