import 'package:flutter/material.dart';

import 'Overview.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({Key? key}) : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final PageController _pageController = PageController();
  final Map<String, TextEditingController> _consumptionControllers = {
    'Beef': TextEditingController(),
    'Chicken': TextEditingController(),
    'Fish': TextEditingController(),
    'Pork': TextEditingController(),
  };
  final TextEditingController _flightController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _consumptionControllers.values
        .forEach((controller) => controller.dispose());
    _flightController.dispose();
    super.dispose();
  }

  void nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void navigateToOverview() {
    final Map<String, double> meatCo2PerKg = {
      'Beef': 27.0,
      'Chicken': 6.9,
      'Fish': 4.5,
      'Pork': 12.1,
    };

    double beefCo2Impact =
        (double.tryParse(_consumptionControllers['Beef']?.text ?? '0') ?? 0.0) *
            meatCo2PerKg['Beef']!;
    double chickenCo2Impact =
        (double.tryParse(_consumptionControllers['Chicken']?.text ?? '0') ??
                0.0) *
            meatCo2PerKg['Chicken']!;
    double fishCo2Impact =
        (double.tryParse(_consumptionControllers['Fish']?.text ?? '0') ?? 0.0) *
            meatCo2PerKg['Fish']!;
    double porkCo2Impact =
        (double.tryParse(_consumptionControllers['Pork']?.text ?? '0') ?? 0.0) *
            meatCo2PerKg['Pork']!;
    double flightCo2Impact =
        (double.tryParse(_flightController.text) ?? 0.0) * 0.115;

// calculting the total co2
    double totalCo2Impact = beefCo2Impact +
        chickenCo2Impact +
        fishCo2Impact +
        porkCo2Impact +
        flightCo2Impact;

// pushing data to overview page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OverviewPage(
          beefCo2Impact: beefCo2Impact,
          flyCo2Impact: flightCo2Impact,
          totalCo2Impact: totalCo2Impact,
          chickenCo2Impact: chickenCo2Impact,
          fishCo2Impact: fishCo2Impact,
          porkCo2Impact: porkCo2Impact,
          flightCo2Impact: flightCo2Impact,
          userAnswers: [],
          co2Impact: totalCo2Impact,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questionnaire'),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          // the first page for meat question
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                // Header
                Text(
                  'What is your meat consumption within a year?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                ..._consumptionControllers.keys.map((key) {
                  return TextField(
                    controller: _consumptionControllers[key]!,
                    decoration: InputDecoration(
                      labelText: '$key consumption (kg)',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  );
                }).toList(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: nextPage,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
          // the secound page for fly question
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Text(
                  'How many kilometers do you fly in a year?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _flightController,
                  decoration: const InputDecoration(
                    labelText: 'Flight kilometers last year',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: navigateToOverview,
                  child: const Text('Calculate and View Overview'),
                ),
                ElevatedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  ),
                  child: const Text('Previous'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
