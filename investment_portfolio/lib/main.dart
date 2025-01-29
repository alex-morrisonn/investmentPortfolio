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
    {'name': 'AAPL', 'units': 50, 'price': 150.0, 'color': Colors.blue},
    {'name': 'TSLA', 'units': 30, 'price': 700.0, 'color': Colors.red},
    {'name': 'BTC', 'units': 2, 'price': 45000.0, 'color': Colors.orange},
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
            const SizedBox(height: 10),

            // Pie Chart and Table inside a Scrollable View
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Pie Chart
                    SizedBox(
                      height: 250,
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
                    const SizedBox(height: 20),

                    // Investment Table
                    _buildInvestmentTable(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generate pie chart sections from investment data
  List<PieChartSectionData> _generatePieChartSections() {
    double totalInvestment = investments.fold(0, (sum, item) => sum + (item['units'] * item['price']));

    return investments.map((investment) {
      double value = investment['units'] * investment['price'];
      return PieChartSectionData(
        value: value,
        title: '${((value / totalInvestment) * 100).toStringAsFixed(1)}%',
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
            Text('${investment['name']} - \$${(investment['units'] * investment['price']).toStringAsFixed(2)}'),
          ],
        );
      }).toList(),
    );
  }

  // Build the investment table
  Widget _buildInvestmentTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Investment')),
          DataColumn(label: Text('Units')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Total Value')),
        ],
        rows: investments.map((investment) {
          double totalValue = investment['units'] * investment['price'];
          return DataRow(cells: [
            DataCell(Text(investment['name'])),
            DataCell(Text('${investment['units']}')),
            DataCell(Text('\$${investment['price'].toStringAsFixed(2)}')),
            DataCell(Text('\$${totalValue.toStringAsFixed(2)}')),
          ]);
        }).toList(),
      ),
    );
  }
}