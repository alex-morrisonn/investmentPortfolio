import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investment Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Investment Portfolio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Investment data (can be replaced with API data later)
  final List<Map<String, dynamic>> investments = [
    {'name': 'AAPL', 'value': 7500.0, 'color': Colors.blue},
    {'name': 'TSLA', 'value': 21000.0, 'color': Colors.red},
    {'name': 'BTC', 'value': 90000.0, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Investment Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: _generatePieChartSections(),
                  centerSpaceRadius: 50,
                  sectionsSpace: 3,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  // Generate pie chart sections from investment data
  List<PieChartSectionData> _generatePieChartSections() {
    double totalInvestment = investments.fold(0, (sum, item) => sum + item['value']);

    return investments.map((investment) {
      return PieChartSectionData(
        value: investment['value'],
        title: '${((investment['value'] / totalInvestment) * 100).toStringAsFixed(1)}%',
        color: investment['color'],
        radius: 80,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  // Build a legend for the pie chart
  Widget _buildLegend() {
    return Column(
      children: investments.map((investment) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(width: 16, height: 16, color: investment['color']),
            const SizedBox(width: 8),
            Text('${investment['name']} - \$${investment['value'].toStringAsFixed(2)}'),
          ],
        );
      }).toList(),
    );
  }
}