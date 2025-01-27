import 'package:flutter/material.dart';

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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Investment')),
                    DataColumn(label: Text('Units')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Value')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('AAPL')),
                      DataCell(Text('50')),
                      DataCell(Text('\$150')),
                      DataCell(Text('\$7500')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('TSLA')),
                      DataCell(Text('30')),
                      DataCell(Text('\$700')),
                      DataCell(Text('\$21000')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('BTC')),
                      DataCell(Text('2')),
                      DataCell(Text('\$45000')),
                      DataCell(Text('\$90000')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}