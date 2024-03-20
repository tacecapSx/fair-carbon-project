import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  final double beefCo2Impact;
  final double flyCo2Impact;

  const OverviewPage({
    Key? key,
    required this.beefCo2Impact,
    required this.flyCo2Impact,
    required double totalCo2Impact,
    required double chickenCo2Impact,
    required double fishCo2Impact,
    required double porkCo2Impact,
    required double flightCo2Impact,
    required List<String> userAnswers,
    required double co2Impact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalCo2Emission = beefCo2Impact + flyCo2Impact;
    double averageCo2Emission = 8800;
    double difference = totalCo2Emission - averageCo2Emission;
    double percentageDifference = (difference / averageCo2Emission) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CO2 Impact Overview'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                    enabled: true,
                  ),
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: beefCo2Impact,
                      title: '${beefCo2Impact.toStringAsFixed(2)} kg CO2',
                      radius: 100,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      badgePositionPercentageOffset: .98,
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: flyCo2Impact,
                      title: '${flyCo2Impact.toStringAsFixed(2)} kg CO2',
                      radius: 100,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      badgePositionPercentageOffset: .98,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 200,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LegendWidget(
                      color: Colors.red, text: 'Beef CO2 Impact'),
                  const SizedBox(height: 4),
                  const LegendWidget(
                      color: Colors.blue, text: 'Flight CO2 Impact'),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: difference > 0 ? Colors.redAccent : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      difference > 0
                          ? 'Above average emissions'
                          : 'Below average emissions',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${percentageDifference.abs().toStringAsFixed(2)}% ${difference > 0 ? 'above' : 'below'} average',
                    style: TextStyle(
                      color: difference > 0 ? Colors.redAccent : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegendWidget extends StatelessWidget {
  final Color color;
  final String text;

  const LegendWidget({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
