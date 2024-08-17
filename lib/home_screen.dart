import 'package:flutter/material.dart';
import 'backend.dart';
import 'login.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// User currentUser = appUsers[userIndex];
User currentUser = User(
    username: "",
    password: "",
    email: "",
    dateOfBirth: DateTime.now(),
    phoneNumber: "");

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  // final double toDisplay = appUsers[0].income - appUsers[0].expense;
  final List<PieChartObject> data = [
    PieChartObject(
      amount: 30,
      category: "Fi",
      pieColor: charts.ColorUtil.fromDartColor(Colors.blueAccent),
    ),
    PieChartObject(
        category: "F&B",
        amount: 30,
        pieColor: charts.ColorUtil.fromDartColor(Colors.deepOrangeAccent)),
    PieChartObject(
        category: "El",
        amount: 30,
        pieColor: charts.ColorUtil.fromDartColor(Colors.pinkAccent)),
  ];
  final List<LineChartObject> lineData = [
    LineChartObject(
        year: 2020,
        amount: 30,
        lineColor: charts.ColorUtil.fromDartColor(Colors.black)),
    LineChartObject(
        year: 2021,
        amount: 50,
        lineColor: charts.ColorUtil.fromDartColor(Colors.black)),
    LineChartObject(
        year: 2022,
        amount: 70,
        lineColor: charts.ColorUtil.fromDartColor(Colors.black)),
  ];
  double balanceText = currentUser.displayBalance();
  double incomeText = currentUser.income;
  double expenseText = currentUser.expense;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pense')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Balance:',
            style: TextStyle(fontSize: 18),
          ),
          Text('$balanceText'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Income:'),
              Text('Expense:'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${currentUser.income}'),
              Text('$expenseText'),
            ],
          ),
          Container(
            child: LineChart(lineData: lineData),
            // child: PieChart(data: data),
          ),
        ],
      ),
    );
  }
}

class PieChart extends StatelessWidget {
  final List<PieChartObject> data;
  // PieChart({Key? key}) : super (key : key);
  PieChart({required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<PieChartObject, String>> series = [
      charts.Series(
        id: "transactions",
        data: data,
        domainFn: (PieChartObject series, _) => series.category,
        measureFn: (PieChartObject series, _) => series.amount,
        colorFn: (PieChartObject series, _) => series.pieColor,
        labelAccessorFn: (PieChartObject series, _) =>
            '${series.category}: ${series.amount}',
      ),
    ];
    return Container(
      height: 300,
      padding: EdgeInsets.all(15),
      // child: Card(
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: <Widget>[
            Text(
              "Category split of transactions",
            ),
            Expanded(
              child: charts.PieChart(series,
                  // add labels
                  // defaultRenderer: charts.ArcRendererConfig(
                  //   arcRendererDecorators: [
                  //     charts.ArcLabelDecorator(
                  //       labelPosition: charts.ArcLabelPosition.outside,
                  //     ),
                  //   ],
                  // ),
                  animate: true),
            )
          ],
        ),
      ),
      // ),
    );
  }
}

class PieChartObject {
  final String category;
  final int amount;
  final charts.Color pieColor;
  PieChartObject(
      {required this.category, required this.amount, required this.pieColor});
}

class LineChart extends StatelessWidget {
  final List<LineChartObject> lineData;
  LineChart({required this.lineData});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<LineChartObject, num>> series = [
      charts.Series(
          id: "transactons",
          data: lineData,
          domainFn: (LineChartObject series, _) => series.year,
          measureFn: (LineChartObject series, _) => series.amount,
          colorFn: (LineChartObject series, _) => series.lineColor),
    ];
    return Container(
      height: 300,
      width: 300,
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Expanded(
            child: charts.LineChart(
              series,
              domainAxis: const charts.NumericAxisSpec(
                tickProviderSpec:
                    charts.BasicNumericTickProviderSpec(zeroBound: false),
                viewport: charts.NumericExtents(2020.0, 2022.0),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  desiredTickCount:
                      8, // Adjust the desired number of ticks on the y-axis
                ),
              ),
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartObject {
  final int year;
  final int amount;
  final charts.Color lineColor;
  LineChartObject(
      {required this.year, required this.amount, required this.lineColor});
}
