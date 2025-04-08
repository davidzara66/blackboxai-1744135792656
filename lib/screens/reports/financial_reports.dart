import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:financial_manager/services/database_service.dart';
import 'package:financial_manager/services/export_service.dart';
import 'package:financial_manager/models/sale_purchase_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FinancialReportsScreen extends StatelessWidget {
  const FinancialReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportReport(context, format: 'pdf'),
          ),
          IconButton(
            icon: const Icon(Icons.grid_on),
            onPressed: () => _exportReport(context, format: 'excel'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: StreamBuilder<List<SalePurchase>>(
                stream: Provider.of<DatabaseService>(context).getSalesPurchases(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SfCartesianChart(
                      title: ChartTitle(text: 'Sales vs Purchases (Last 30 Days)'),
                      legend: Legend(isVisible: true),
                      series: <ChartSeries>[
                        ColumnSeries<Map<String, dynamic>, DateTime>(
                          dataSource: _prepareData(snapshot.data!),
                          xValueMapper: (data, _) => data['date'],
                          yValueMapper: (data, _) => data['sales'],
                          name: 'Sales',
                          color: Colors.green,
                        ),
                        ColumnSeries<Map<String, dynamic>, DateTime>(
                          dataSource: _prepareData(snapshot.data!),
                          xValueMapper: (data, _) => data['date'],
                          yValueMapper: (data, _) => data['purchases'],
                          name: 'Purchases',
                          color: Colors.red,
                        ),
                      ],
                      primaryXAxis: DateTimeAxis(
                        intervalType: DateTimeIntervalType.days,
                        interval: 5,
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(height: 20),
            // Additional reports can be added here
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _prepareData(List<SalePurchase> transactions) {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final recentTransactions = transactions.where((t) => t.date.isAfter(thirtyDaysAgo));
    
    final Map<DateTime, Map<String, double>> data = {};
    
    for (final t in recentTransactions) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);
      data.putIfAbsent(date, () => {'sales': 0, 'purchases': 0});
      
      if (t.type == TransactionType.sale) {
        data[date]!['sales'] = data[date]!['sales']! + t.total;
      } else {
        data[date]!['purchases'] = data[date]!['purchases']! + t.total;
      }
    }

    return data.entries.map((e) => {
      'date': e.key,
      'sales': e.value['sales'],
      'purchases': e.value['purchases'],
    }).toList();
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