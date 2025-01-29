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

  // Function to remove an investment
  void _removeInvestment(int index) {
    setState(() {
      investments.removeAt(index);
    });
  }

  // Function to add an investment
  void _addInvestment(String name, String category, double value) {
    setState(() {
      investments.add({
        'name': name,
        'value': value,
        'category': category,
        'color': _getCategoryColor(category), // Assign a color dynamically
      });
    });
  }

  // Function to get color based on category
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'stock':
        return Colors.blueAccent;
      case 'crypto':
        return Colors.amberAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Portfolio Diversity"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddInvestmentDialog(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            const SizedBox(height: 30),

            Expanded(child: _buildInvestmentTable()), // Table section
          ],
        ),
      ),
    );
  }

  // Generate pie chart sections dynamically
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

  // Build the investment table with add/remove functionality
  Widget _buildInvestmentTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: DataTable(
          columnSpacing: 25,
          headingRowHeight: 40,
          dataRowHeight: 50,
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[900]!),
          columns: const [
            DataColumn(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(label: Text('Value (A\$)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(label: Text('Share %', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          ],
          rows: List.generate(investments.length, (index) {
            var investment = investments[index];
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
                    const SizedBox(width: 10),
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
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeInvestment(index),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Show Add Investment Dialog
  void _showAddInvestmentDialog() {
    String stockName = "";
    String category = "Stock";
    double value = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Investment"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Stock Name"),
                onChanged: (val) => stockName = val,
              ),
              DropdownButton<String>(
                value: category,
                onChanged: (newValue) => setState(() => category = newValue!),
                items: ["Stock", "Crypto"].map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Value (A\$)"),
                keyboardType: TextInputType.number,
                onChanged: (val) => value = double.tryParse(val) ?? 0.0,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(onPressed: () { _addInvestment(stockName, category, value); Navigator.pop(context); }, child: const Text("Add")),
          ],
        );
      },
    );
  }
}