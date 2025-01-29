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
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const PortfolioScreen(),
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final List<Map<String, dynamic>> investments = [
    {'name': 'BHP.AX', 'value': 510.90, 'category': 'Stock', 'color': Colors.blue},
    {'name': 'GMG.AX', 'value': 458.77, 'category': 'Stock', 'color': Colors.red},
    {'name': 'AAPL', 'value': 1500.50, 'category': 'Stock', 'color': Colors.green},
    {'name': 'TSLA', 'value': 1800.25, 'category': 'Stock', 'color': Colors.orange},
    {'name': 'BTC', 'value': 728.84, 'category': 'Crypto', 'color': Colors.amber},
  ];

  double get totalHoldings =>
      investments.fold(0, (sum, investment) => sum + investment['value']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Portfolio Diversity"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Global padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pie Chart Section with Proper Spacing (No Extra Title)
            Container(
              height: 280,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: _generatePieChartSections(),
                      centerSpaceRadius: 80,
                      sectionsSpace: 3,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Holdings",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      Text(
                        "A\$${totalHoldings.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30), // Extra space before table

            // Investment Table with Proper Spacing
            Expanded(child: _buildInvestmentTable()),
          ],
        ),
      ),
    );
  }

  // Generate pie chart sections for individual stocks
  List<PieChartSectionData> _generatePieChartSections() {
    return investments.map((investment) {
      return PieChartSectionData(
        value: investment['value'],
        title: investment['name'],
        color: investment['color'],
        radius: 80,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  // Build the investment table with colored boxes and better row spacing
  Widget _buildInvestmentTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10), // Add space around the table
        child: DataTable(
          columnSpacing: 25, // More spacing between columns
          headingRowHeight: 40, // Increased header row height
          dataRowHeight: 50, // More height for better row spacing
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[900]!),
          columns: const [
            DataColumn(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(label: Text('Value (A\$)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(label: Text('Share %', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          ],
          rows: investments.map((investment) {
            return DataRow(
              cells: [
                DataCell(Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: investment['color'],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10), // Better spacing between box and text
                    Text(investment['name'], style: const TextStyle(color: Colors.white)),
                  ],
                )),
                DataCell(Text(investment['category'], style: const TextStyle(color: Colors.white70))),
                DataCell(Text("A\$${investment['value'].toStringAsFixed(2)}", style: const TextStyle(color: Colors.white))),
                DataCell(
                  Text(
                    "${((investment['value'] / totalHoldings) * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}