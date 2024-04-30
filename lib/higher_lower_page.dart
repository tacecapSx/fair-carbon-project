import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CO2ComparisonItem {
  final String description;
  final double co2Impact;
  final String imagePath;

  CO2ComparisonItem({required this.description, required this.co2Impact, required this.imagePath});

  factory CO2ComparisonItem.fromJson(Map<String, dynamic> json) {
    return CO2ComparisonItem(
      description: json['description'],
      co2Impact: (json['co2Impact'] as num).toDouble(),
      imagePath: json['imagePath'],
    );
  }
}

class HigherLowerPage extends StatefulWidget {
  const HigherLowerPage({Key? key}) : super(key: key);

  @override
  _HigherLowerPageState createState() => _HigherLowerPageState();
}

class _HigherLowerPageState extends State<HigherLowerPage> {
  List<CO2ComparisonItem> items = [];
  int currentIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions().then((loadedItems) {
      setState(() {
        items = loadedItems;
      });
    });
  }
// load json spørgsmål
  Future<List<CO2ComparisonItem>> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions.json');
    final data = await json.decode(response);
    return List<CO2ComparisonItem>.from(
      data.map((item) => CO2ComparisonItem.fromJson(item))
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading questions...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    CO2ComparisonItem current = items[currentIndex];
    CO2ComparisonItem next = items[(currentIndex + 1) % items.length];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildItemPanel(current, context, showCO2: true),
                _buildItemPanel(next, context, showCO2: false),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.black87,
            child: Center(
              child: Text(
                'Score: $score',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemPanel(CO2ComparisonItem item, BuildContext context, {required bool showCO2}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(item.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.description,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (showCO2) Text(
              '${item.co2Impact.toStringAsFixed(2)} kg CO2',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellow),
            ),
            if (!showCO2) ElevatedButton(
              onPressed: () => evaluateAnswer(true, item.co2Impact),
              child: Text('Higher'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            if (!showCO2) ElevatedButton(
              onPressed: () => evaluateAnswer(false, item.co2Impact),
              child: Text('Lower'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
// checker scvar 
  void evaluateAnswer(bool higher, double nextImpact) {
    CO2ComparisonItem current = items[currentIndex];
    bool correct = (higher && nextImpact > current.co2Impact) ||
                   (!higher && nextImpact < current.co2Impact);

    if (correct) {
      setState(() {
        score++;
        currentIndex = (currentIndex + 1) % items.length;
      });
    } else {
      setState(() {
        score = 0; // Reset hvis forkert svar
      });
      showIncorrectDialog(nextImpact);
    }
  }
 // lav dialog boks 
  void showIncorrectDialog(double nextImpact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrect!'),
          content: Text('The correct answer was ${nextImpact > items[currentIndex].co2Impact ? "Higher" : "Lower"} CO2 impact.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                evaluateNext(); 
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }
// opdater index
  void evaluateNext() {
    setState(() {
      currentIndex = (currentIndex + 1) % items.length; 
    });
  }
}
