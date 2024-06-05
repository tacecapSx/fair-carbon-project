

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  final double beefCo2Impact;
  final double chickenCo2Impact;
  final double porkCo2Impact;
  final double flightCo2Impact;
  final double vehicleCo2Impact;
  final double electricityCo2Impact;
  final double gasCo2Impact;
  final double totalCo2Impact;

  const OverviewPage({
    Key? key,
    this.beefCo2Impact = 0,
    this.chickenCo2Impact = 0,
    this.porkCo2Impact = 0,
    this.flightCo2Impact = 0,
    this.vehicleCo2Impact = 0,
    this.electricityCo2Impact = 0,
    this.gasCo2Impact = 0,
    required this.totalCo2Impact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double averageCo2Emission = 4000;
    double difference = totalCo2Impact - averageCo2Emission;
    double percentageDifference = (difference / averageCo2Emission) * 100;

//scafold with the piechat form the fl_chart.dart package 
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
                      title: beefCo2Impact > 0
                          ? '${beefCo2Impact.toStringAsFixed(2)} kg CO2'
                          : '',
                      radius: 100,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      badgePositionPercentageOffset: .98,
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: chickenCo2Impact,
                      title: chickenCo2Impact > 0
                          ? '${chickenCo2Impact.toStringAsFixed(2)} kg CO2'
                          : '',
                      radius: 100,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      badgePositionPercentageOffset: .98,
                    ),
                    PieChartSectionData(
                      color: Colors.pink,
                      value: porkCo2Impact,
                      title: porkCo2Impact > 0
                          ? '${porkCo2Impact.toStringAsFixed(2)} kg CO2'
                          : '',
                      radius: 100,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      badgePositionPercentageOffset: .98,
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: flightCo2Impact,
                      title: flightCo2Impact > 0
                          ? '${flightCo2Impact.toStringAsFixed(2)} kg CO2'
                          : '',
                      radius: 100,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      badgePositionPercentageOffset: .98,
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: vehicleCo2Impact,
                      title: vehicleCo2Impact > 0
                          ? '${vehicleCo2Impact.toStringAsFixed(2)} kg CO2'
                          : '',
                      radius: 100,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      badgePositionPercentageOffset: .98,
                    ),
                    PieChartSectionData(
                      color: Colors.yellow,
                      value: electricityCo2Impact,
                      title: electricityCo2Impact > 0
                          ? '${electricityCo2Impact.toStringAsFixed(2)} kg CO2'
                          : '',
                      radius: 100,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      badgePositionPercentageOffset: .98,
                    ),
                    PieChartSectionData(
                      color: Colors.purple,
                      value: gasCo2Impact,
                      title: gasCo2Impact > 0
                          ? '${gasCo2Impact.toStringAsFixed(2)} kg CO2'
                          : '',
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
                  LegendWidget(
                      color: Colors.red, text: 'Beef CO2 Impact'),
                  const SizedBox(height: 4),
                  LegendWidget(
                      color: Colors.orange, text: 'Chicken CO2 Impact'),
                  const SizedBox(height: 4),
                  LegendWidget(
                      color: Colors.pink, text: 'Pork CO2 Impact'),
                  const SizedBox(height: 4),
                  LegendWidget(
                      color: Colors.blue, text: 'Flight CO2 Impact'),
                  const SizedBox(height: 4),
                  LegendWidget(
                      color: Colors.green, text: 'Vehicle CO2 Impact'),
                  const SizedBox(height: 4),
                  LegendWidget(
                      color: Colors.yellow, text: 'Electricity CO2 Impact'),
                  const SizedBox(height: 4),
                  LegendWidget(
                      color: Colors.purple, text: 'Gas CO2 Impact'),
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


