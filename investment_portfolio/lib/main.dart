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
    {'name': 'BHP.AX', 'units': 10, 'stockPrice': 51.09, 'category': 'Stock', 'color': Colors.blue},
    {'name': 'GMG.AX', 'units': 5, 'stockPrice': 91.75, 'category': 'Stock', 'color': Colors.red},
    {'name': 'AAPL', 'units': 2, 'stockPrice': 750.25, 'category': 'Stock', 'color': Colors.green},
    {'name': 'TSLA', 'units': 3, 'stockPrice': 600.75, 'category': 'Stock', 'color': Colors.orange},
    {'name': 'BTC', 'units': 0.05, 'stockPrice': 45000, 'category': 'Crypto', 'color': Colors.amber},
  ];

  double get totalHoldings =>
      investments.fold(0, (sum, investment) => sum + (investment['units'] * investment['stockPrice']));

  // Function to remove an investment
  void _removeInvestment(int index) {
    setState(() {
      investments.removeAt(index);
    });
  }

  // Function to add an investment
  void _addInvestment(String name, String category, double stockPrice, double units) {
    setState(() {
      investments.add({
        'name': name,
        'stockPrice': stockPrice,
        'units': units,
        'category': category,
        'color': _getCategoryColor(category),
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
        value: investment['units'] * investment['stockPrice'],
        title: investment['name'],
        color: investment['color'],
        radius: 80,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  // Build the investment table with swipe-to-delete functionality
  Widget _buildInvestmentTable() {
    return ListView.separated(
      itemCount: investments.length,
      separatorBuilder: (context, index) => const Divider(color: Colors.white24, thickness: 0.5),
      itemBuilder: (context, index) {
        var investment = investments[index];
        double totalValue = investment['units'] * investment['stockPrice'];

        return Dismissible(
          key: Key(investment['name']),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _removeInvestment(index);
          },
          background: Container(
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white, size: 30),
          ),
          child: ListTile(
            leading: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: investment['color'],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            title: Text(investment['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("${investment['category']} • ${investment['units']} units @ A\$${investment['stockPrice'].toStringAsFixed(2)}", style: const TextStyle(color: Colors.white70)),
            trailing: Text(
              "A\$${totalValue.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
            ),
          ),
        );
      },
    );
  }

  // Show Add Investment Dialog
  void _showAddInvestmentDialog() {
    String stockName = "";
    String category = "Stock";
    double stockPrice = 0.0;
    double units = 0.0;

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
                decoration: const InputDecoration(labelText: "Units"),
                keyboardType: TextInputType.number,
                onChanged: (val) => units = double.tryParse(val) ?? 0.0,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Stock Price (A\$)"),
                keyboardType: TextInputType.number,
                onChanged: (val) => stockPrice = double.tryParse(val) ?? 0.0,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(onPressed: () { _addInvestment(stockName, category, stockPrice, units); Navigator.pop(context); }, child: const Text("Add")),
          ],
        );
      },
    );
  }
}