// Christian s214923
// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'overview_page.dart';
import 'database.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  QuestionnairePageState createState() => QuestionnairePageState();
}

class QuestionnairePageState extends State<QuestionnairePage> {
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

  bool _updating = false; 

  @override
  void dispose() {
    _pageController.dispose();
    _dailyControllers.values.forEach((controller) => controller.dispose());
    _weeklyControllers.values.forEach((controller) => controller.dispose());
    _yearlyControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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

//convert autormatically between day, week or year with data
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
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

//predefined values such as how much co2 1 kg of beef produces
void navigateToOverview() {
  final Map<String, double> meatCo2PerKg = {
    'Beef': 27.0,
    'Chicken': 6.9,
    'Pork': 12.1,
  };

  // Check if all the required fields are filled because else error whcich locks the mouse :(
  for (var key in _yearlyControllers.keys) {
    if (_yearlyControllers[key]!.text.isEmpty) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill all of the fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the function if validation fails
    }
  }

  // Calculate CO2 impact for each category
  double beefCo2Impact = (double.tryParse(_yearlyControllers['Beef']?.text ?? '0') ?? 0.0) * meatCo2PerKg['Beef']!;
  double chickenCo2Impact = (double.tryParse(_yearlyControllers['Chicken']?.text ?? '0') ?? 0.0) * meatCo2PerKg['Chicken']!;
  double porkCo2Impact = (double.tryParse(_yearlyControllers['Pork']?.text ?? '0') ?? 0.0) * meatCo2PerKg['Pork']!;
  double flightCo2Impact = (double.tryParse(_yearlyControllers['Flight']?.text ?? '0') ?? 0.0) * 0.115;
  double vehicleCo2Impact = (double.tryParse(_yearlyControllers['Vehicle']?.text ?? '0') ?? 0.0) * 0.192;
  double electricityCo2Impact = (double.tryParse(_yearlyControllers['Electricity']?.text ?? '0') ?? 0.0) * 0.527;
  double gasCo2Impact = (double.tryParse(_yearlyControllers['Gas']?.text ?? '0') ?? 0.0) * 2.204;

  double beefImpact = (double.tryParse(_yearlyControllers['Beef']?.text ?? '0') ?? 0.0);
  double chickenImpact = (double.tryParse(_yearlyControllers['Chicken']?.text ?? '0') ?? 0.0);
  double porkImpact = (double.tryParse(_yearlyControllers['Pork']?.text ?? '0') ?? 0.0);
  double flightImpact = (double.tryParse(_yearlyControllers['Flight']?.text ?? '0') ?? 0.0);
  double vehicleImpact = (double.tryParse(_yearlyControllers['Vehicle']?.text ?? '0') ?? 0.0);
  double electricityImpact = (double.tryParse(_yearlyControllers['Electricity']?.text ?? '0') ?? 0.0);
  double gasImpact = (double.tryParse(_yearlyControllers['Gas']?.text ?? '0') ?? 0.0);

  // Total sum of all CO2 usage
  double totalCo2Impact = beefCo2Impact + chickenCo2Impact + porkCo2Impact + flightCo2Impact + vehicleCo2Impact + electricityCo2Impact + gasCo2Impact;

  //Oskar (Update database)
  updateDataList("Questionnaire/Beef", beefImpact);
  updateDataList("Questionnaire/Chicken", chickenImpact);
  updateDataList("Questionnaire/Pork", porkImpact);
  updateDataList("Questionnaire/Flying", flightImpact);
  updateDataList("Questionnaire/Vehicle", vehicleImpact);
  updateDataList("Questionnaire/Electricity", electricityImpact);
  updateDataList("Questionnaire/Gas", gasImpact);

  // sends data to overview page with the calculated data
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
        beefImpact: beefImpact,
        chickenImpact: chickenImpact,
        porkImpact: porkImpact,
        flightImpact: flightImpact,
        vehicleImpact: vehicleImpact,
        electricityImpact: electricityImpact,
        gasImpact: gasImpact,
      ),
    ),
  );
}

  Widget questionnaireField(TextEditingController controller, String defaultText) {
    return SizedBox(
      width: 120,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: defaultText,
          fillColor: Colors.white,
          filled: true,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  Widget questionnaireSection(String title, Widget f1, Widget f2, Widget f3) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            f1,
            const SizedBox(width: 10,),
            const Text("or"),
            const SizedBox(width: 10,),
            f2,
            const SizedBox(width: 10,),
            const Text("or"),
            const SizedBox(width: 10,),
            f3,
          ],
        ),
        const SizedBox(height: 80,),
      ],
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
        physics: const NeverScrollableScrollPhysics(),
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
                  return questionnaireSection(
                    '$key eaten',
                    questionnaireField(_dailyControllers[key]!, ("Daily (kg)")),
                    questionnaireField(_weeklyControllers[key]!, ("Weekly (kg)")),
                    questionnaireField(_yearlyControllers[key]!, ("Yearly (kg)")),
                  );
                }),
                ElevatedButton(
                  onPressed: nextPage,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
          // Page two questions distance traveled
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const Text(
                  'Travel',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                questionnaireSection(
                  'Distance traveled (airplane)',
                  questionnaireField(_dailyControllers['Flight']!, ("Daily (km)")),
                  questionnaireField(_weeklyControllers['Flight']!, ("Weekly (km)")),
                  questionnaireField(_yearlyControllers['Flight']!, ("Yearly (km)")),
                ),
                questionnaireSection(
                  'Distance traveled (motor vehicle)',
                  questionnaireField(_dailyControllers['Vehicle']!, ("Daily (km)")),
                  questionnaireField(_weeklyControllers['Vehicle']!, ("Weekly (km)")),
                  questionnaireField(_yearlyControllers['Vehicle']!, ("Yearly (km)")),
                ),
                ElevatedButton(
                  onPressed: nextPage,
                  child: const Text('Next'),
                ),
                ElevatedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
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
                questionnaireSection(
                  'Electricity used',
                  questionnaireField(_dailyControllers['Electricity']!, ("Daily (kWh)")),
                  questionnaireField(_weeklyControllers['Electricity']!, ("Weekly (kWh)")),
                  questionnaireField(_yearlyControllers['Electricity']!, ("Yearly (kWh)")),
                ),
                questionnaireSection(
                  'Gas used',
                  questionnaireField(_dailyControllers['Gas']!, ("Daily (kWh)")),
                  questionnaireField(_weeklyControllers['Gas']!, ("Weekly (kWh)")),
                  questionnaireField(_yearlyControllers['Gas']!, ("Yearly (kWh)")),
                ),
                ElevatedButton(
                  onPressed: navigateToOverview,
                  child: const Text('Calculate and View Overview'),
                ),
                ElevatedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
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
