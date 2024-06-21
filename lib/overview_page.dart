// Christian s214923
import 'package:carbon_footprint/custom_widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter/services.dart';

class OverviewPage extends StatelessWidget {
  final double beefCo2Impact;
  final double chickenCo2Impact;
  final double porkCo2Impact;
  final double flightCo2Impact;
  final double vehicleCo2Impact;
  final double electricityCo2Impact;
  final double gasCo2Impact;
  final double totalCo2Impact;
  final double beefImpact;
  final double chickenImpact;
  final double porkImpact;
  final double flightImpact;
  final double vehicleImpact;
  final double electricityImpact;
  final double gasImpact;

  const OverviewPage({
    super.key,
    this.beefCo2Impact = 0,
    this.chickenCo2Impact = 0,
    this.porkCo2Impact = 0,
    this.flightCo2Impact = 0,
    this.vehicleCo2Impact = 0,
    this.electricityCo2Impact = 0,
    this.gasCo2Impact = 0,
    required this.totalCo2Impact,
    required this.beefImpact,
    required this.chickenImpact,
    required this.porkImpact,
    required this.flightImpact,
    required this.vehicleImpact,
    required this.electricityImpact,
    required this.gasImpact,
  });

  @override
  Widget build(BuildContext context) {
    // Average data for consumption
    double averageBeefImpact = 24.33;
    double averageChickenImpact = 13.46;
    double averagePorkImpact = 24.56;
    double averageFlightImpact = 2200;
    double averageVehicleImpact = 5000;
    double averageElectricityImpact = 5900;
    double averageGasImpact = 600;

    // Calculate the CO2 impact by multiplying with the amount of CO2 per kg of each 
    double averageBeefCo2Impact = averageBeefImpact * 27.0;
    double averageChickenCo2Impact = averageChickenImpact * 6.9;
    double averagePorkCo2Impact = averagePorkImpact * 12.1;
    double averageFlightCo2Impact = averageFlightImpact * 0.18;
    double averageVehicleCo2Impact = averageVehicleImpact * 0.1;
    double averageElectricityCo2Impact = averageElectricityImpact * 2;
    double averageGasCo2Impact = averageGasImpact * 4;

    double averageTotalCo2Impact = averageBeefCo2Impact +
        averageChickenCo2Impact +
        averagePorkCo2Impact +
        averageFlightCo2Impact +
        averageVehicleCo2Impact +
        averageElectricityCo2Impact +
        averageGasCo2Impact;

    // Percentage difference
    double difference = totalCo2Impact - averageTotalCo2Impact;
    double percentageDifference = averageTotalCo2Impact != 0 ? (difference / averageTotalCo2Impact) * 100 : 0;

    return Scaffold(
      appBar: const HeaderWidget(),
      body: Stack(
        children: [
          // Build first pie chart 
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                enabled: true,
              ),
              sections: _buildPieSections([
                beefCo2Impact,
                chickenCo2Impact,
                porkCo2Impact,
                flightCo2Impact,
                vehicleCo2Impact,
                electricityCo2Impact,
                gasCo2Impact,
              ], [
                Colors.red,
                Colors.orange,
                Colors.pink,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
              ]),
              sectionsSpace: 2,
              centerSpaceRadius: 150,
            ),
          ),
          /*Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    style: const TextStyle(color: Colors.white),
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
          ),*/
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 220,), //used to line up the pie charts
              Expanded(
                // Build pie chart number two
                child: Transform.scale( //scale up the user's chart to achieve the chart-in-chart effect
                  scale: 0.75,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                        enabled: true,
                      ),
                      sections: _buildPieSections([
                        averageBeefCo2Impact,
                        averageChickenCo2Impact,
                        averagePorkCo2Impact,
                        averageFlightCo2Impact,
                        averageVehicleCo2Impact,
                        averageElectricityCo2Impact,
                        averageGasCo2Impact,
                      ], [
                        Colors.red,
                        Colors.orange,
                        Colors.pink,
                        Colors.blue,
                        Colors.green,
                        Colors.yellow,
                        Colors.purple,
                      ]),
                      sectionsSpace: 2,
                      centerSpaceRadius: 70,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegend(
                  "Your CO2 impact (outer chart)",
                  [
                    'Beef',
                    'Chicken',
                    'Pork',
                    'Flight',
                    'Vehicle',
                    'Electricity',
                    'Gas',
                  ], [
                    beefImpact,
                    chickenImpact,
                    porkImpact,
                    flightImpact,
                    vehicleImpact,
                    electricityImpact,
                    gasImpact,
                  ], [
                    Colors.red,
                    Colors.orange,
                    Colors.pink,
                    Colors.blue,
                    Colors.green,
                    Colors.yellow,
                    Colors.purple,
                  ], totalCo2Impact.toStringAsFixed(2)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                          style: const TextStyle(color: Colors.white),
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
                      TextButton( //Sigurd (Clipboard share results)
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                            text: "My carbon footprint (${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}):\nBeef: $beefCo2Impact kg CO2\nChicken: $chickenCo2Impact kg CO2\nPork: $porkCo2Impact kg CO2\nFlights: $flightCo2Impact kg CO2\nVehicle: $vehicleCo2Impact kg CO2\nElectricity: $electricityCo2Impact kg CO2\nGas: $gasCo2Impact kg CO2\nhttps://tacecapsx.github.io/fair-carbon-project/" //string formatting for our clipboard
                          ),
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Success!"),
                              content: const Text("Copied to clipboard! Paste anywhere!"),
                              actions: [
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: AppColors.whiteTextColor,
                        foregroundColor: AppColors.blackTextColor,
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text("Save results"),
                    ),
                    ],
                  ),
                  _buildLegend(
                  "Average Danish impact (inner chart)",  
                  [
                    'Beef',
                    'Chicken',
                    'Pork',
                    'Flight',
                    'Vehicle',
                    'Electricity',
                    'Gas',
                  ], [
                    averageBeefImpact,
                    averageChickenImpact,
                    averagePorkImpact,
                    averageFlightImpact,
                    averageVehicleImpact,
                    averageElectricityImpact,
                    averageGasImpact,
                  ], [
                    Colors.red,
                    Colors.orange,
                    Colors.pink,
                    Colors.blue,
                    Colors.green,
                    Colors.yellow,
                    Colors.purple,
                  ], averageTotalCo2Impact.toStringAsFixed(2)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


//fixes zero exeption 
  List<PieChartSectionData> _buildPieSections(List<double> values, List<Color> colors) {
    double totalValue = values.reduce((a, b) => a + b);
    if (totalValue == 0) {
      //  map some of the data from avarege dansih co2 emession to the piechart
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 1,
          showTitle: false,  //remove titles so its more readable
          radius: 100,
        ),
      ];
    }
    return values.asMap().entries.map((entry) {
      int index = entry.key;
      double value = entry.value;
      return PieChartSectionData(
        color: colors[index],
        value: value,
        showTitle: false, //remove titles so its more readable
        radius: 100,
      );
    }).toList();
  }

  Widget _buildLegend(String title, List<String> labels, List<double> values, List<Color> colors, String totalImpact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),
        ...labels.asMap().entries.map((entry) {
          int index = entry.key;
          String label = entry.value;
          return LegendWidget(
            color: colors[index],
            text: label,
            value: '${values[index].toStringAsFixed(2)} ${_getUnit(label)}',
          );
        }),
        const SizedBox(height: 20),
        Text(
          'Total CO2 Impact: $totalImpact kg CO2',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  String _getUnit(String label) {
    switch (label) {
      case 'Flight':
      case 'Vehicle':
        return 'km';
      case 'Electricity':
      case 'Gas':
        return 'kWh';
      default:
        return 'kg';
    }
  }
}

class LegendWidget extends StatelessWidget {
  final Color color;
  final String text;
  final String value;

  const LegendWidget({
    super.key,
    required this.color,
    required this.text,
    required this.value,
  });

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
        const SizedBox(width: 8),
        Text(value),
      ],
    );
  }
}
