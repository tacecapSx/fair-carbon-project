import 'package:flutter/material.dart';
import 'Overview.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({Key? key}) : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final PageController _pageController = PageController();
  
  // making controllers for the different categories 
  final Map<String, TextEditingController> _dailyControllers = {
    'Beef': TextEditingController(),
    'Chicken': TextEditingController(),
    'Pork': TextEditingController(),
    'Flight': TextEditingController(),
    'Vehicle': TextEditingController(),
    'Electricity': TextEditingController(),
    'Gas': TextEditingController(),
  };
  final Map<String, TextEditingController> _weeklyControllers = {
    'Beef': TextEditingController(),
    'Chicken': TextEditingController(),
    'Pork': TextEditingController(),
    'Flight': TextEditingController(),
    'Vehicle': TextEditingController(),
    'Electricity': TextEditingController(),
    'Gas': TextEditingController(),
  };
  final Map<String, TextEditingController> _yearlyControllers = {
    'Beef': TextEditingController(),
    'Chicken': TextEditingController(),
    'Pork': TextEditingController(),
    'Flight': TextEditingController(),
    'Vehicle': TextEditingController(),
    'Electricity': TextEditingController(),
    'Gas': TextEditingController(),
  };

  bool _updating = false; // preventing infinite loop issue

  @override
  void dispose() {
    // remove controllers with no use anymore
    _pageController.dispose();
    _dailyControllers.values.forEach((controller) => controller.dispose());
    _weeklyControllers.values.forEach((controller) => controller.dispose());
    _yearlyControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Add listeners automatically to update textfields
    _dailyControllers.forEach((key, controller) {
      controller.addListener(() {
        if (!_updating) {
          updateConsumptionValues(key, controller, 'daily');
        }
      });
    });
    _weeklyControllers.forEach((key, controller) {
      controller.addListener(() {
        if (!_updating) {
          updateConsumptionValues(key, controller, 'weekly');
        }
      });
    });
    _yearlyControllers.forEach((key, controller) {
      controller.addListener(() {
        if (!_updating) {
          updateConsumptionValues(key, controller, 'yearly');
        }
      });
    });
  }

  // automatic update of each textfield when filling one 
  void updateConsumptionValues(String key, TextEditingController controller, String type) {
    double value = double.tryParse(controller.text) ?? 0.0;
    _updating = true; // preventing infinite loop issue
    if (type == 'daily') {
      _weeklyControllers[key]?.text = (value * 7).toStringAsFixed(1);
      _yearlyControllers[key]?.text = (value * 365).toStringAsFixed(1);
    } else if (type == 'weekly') {
      _dailyControllers[key]?.text = (value / 7).toStringAsFixed(1);
      _yearlyControllers[key]?.text = (value * 52).toStringAsFixed(1);
    } else if (type == 'yearly') {
      _dailyControllers[key]?.text = (value / 365).toStringAsFixed(1);
      _weeklyControllers[key]?.text = (value / 52).toStringAsFixed(1);
    }
    _updating = false; // preventing infinite loop issue
  }

  // Function to navigate to the next page
  void nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  //  the co2 cost for each kg
  void navigateToOverview() {
    final Map<String, double> meatCo2PerKg = {
      'Beef': 27.0,
      'Chicken': 6.9,
      'Pork': 12.1,
    };

    // Calculate CO2 impact for each category
    double beefCo2Impact = (double.tryParse(_yearlyControllers['Beef']?.text ?? '0') ?? 0.0) * meatCo2PerKg['Beef']!;
    double chickenCo2Impact = (double.tryParse(_yearlyControllers['Chicken']?.text ?? '0') ?? 0.0) * meatCo2PerKg['Chicken']!;
    double porkCo2Impact = (double.tryParse(_yearlyControllers['Pork']?.text ?? '0') ?? 0.0) * meatCo2PerKg['Pork']!;
    double flightCo2Impact = (double.tryParse(_yearlyControllers['Flight']?.text ?? '0') ?? 0.0) * 0.115;
    double vehicleCo2Impact = (double.tryParse(_yearlyControllers['Vehicle']?.text ?? '0') ?? 0.0) * 0.192;
    double electricityCo2Impact = (double.tryParse(_yearlyControllers['Electricity']?.text ?? '0') ?? 0.0) * 0.527;
    double gasCo2Impact = (double.tryParse(_yearlyControllers['Gas']?.text ?? '0') ?? 0.0) * 2.204;

    // total sum of all CO2 ussage 
    double totalCo2Impact = beefCo2Impact + chickenCo2Impact + porkCo2Impact + flightCo2Impact + vehicleCo2Impact + electricityCo2Impact + gasCo2Impact;

    // Navigate to the overview page with the calculated data pushed 
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OverviewPage(
          beefCo2Impact: beefCo2Impact,
          chickenCo2Impact: chickenCo2Impact,
          porkCo2Impact: porkCo2Impact,
          flightCo2Impact: flightCo2Impact,
          vehicleCo2Impact: vehicleCo2Impact,
          electricityCo2Impact: electricityCo2Impact,
          gasCo2Impact: gasCo2Impact,
          totalCo2Impact: totalCo2Impact,
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
          // Page one questions about meat
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const Text(
                  'Meat consumption',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // make the textfilds with the consumptions 
                ..._dailyControllers.keys.where((key) => key != 'Flight' && key != 'Vehicle' && key != 'Electricity' && key != 'Gas').map((key) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$key eaten',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextField(
                        controller: _dailyControllers[key]!,
                        decoration: const InputDecoration(
                          labelText: 'Daily (kg)',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _weeklyControllers[key]!,
                        decoration: const InputDecoration(
                          labelText: 'Weekly (kg)',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _yearlyControllers[key]!,
                        decoration: const InputDecoration(
                          labelText: 'Yearly (kg)',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: nextPage,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
          // Page two   questions distance traveled
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const Text(
                  'travel',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Distance traveled (airplane)',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _dailyControllers['Flight']!,
                  decoration: const InputDecoration(
                    labelText: 'Daily (km)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _weeklyControllers['Flight']!,
                  decoration: const InputDecoration(
                    labelText: 'Weekly (km)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _yearlyControllers['Flight']!,
                  decoration: const InputDecoration(
                    labelText: 'Yearly (km)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Distance traveled (motor vehicle)',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _dailyControllers['Vehicle']!,
                  decoration: const InputDecoration(
                    labelText: 'Daily (km)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _weeklyControllers['Vehicle']!,
                  decoration: const InputDecoration(
                    labelText: 'Weekly (km)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _yearlyControllers['Vehicle']!,
                  decoration: const InputDecoration(
                    labelText: 'Yearly (km)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: nextPage,
                  child: const Text('Next'),
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
          // Page three for electricity and gas usage
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const Text(
                  'Gas and electricity',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Electricity used',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _dailyControllers['Electricity']!,
                  decoration: const InputDecoration(
                    labelText: 'Daily (kWh)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _weeklyControllers['Electricity']!,
                  decoration: const InputDecoration(
                    labelText: 'Weekly (kWh)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _yearlyControllers['Electricity']!,
                  decoration: const InputDecoration(
                    labelText: 'Yearly (kWh)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Gas used',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _dailyControllers['Gas']!,
                  decoration: const InputDecoration(
                    labelText: 'Daily (kWh)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _weeklyControllers['Gas']!,
                  decoration: const InputDecoration(
                    labelText: 'Weekly (kWh)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _yearlyControllers['Gas']!,
                  decoration: const InputDecoration(
                    labelText: 'Yearly (kWh)',
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
