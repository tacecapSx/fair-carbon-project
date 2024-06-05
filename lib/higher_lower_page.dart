import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'higher_lower_loss_page.dart';

class CO2ComparisonItem {
  final String description;
  final double co2Impact;
  final String imagePath;

  CO2ComparisonItem({
    required this.description,
    required this.co2Impact,
    required this.imagePath,
  });

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

class _HigherLowerPageState extends State<HigherLowerPage>
    with SingleTickerProviderStateMixin {
  List<CO2ComparisonItem> items = [];
  int currentIndex = 0;
  int score = 0;
  bool animationActive = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    loadQuestions().then((loadedItems) {
      setState(() {
        items = loadedItems;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        setState(() {
          animationActive = false;
        });
        evaluateNext();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<CO2ComparisonItem>> loadQuestions() async {
    final String response =
        await rootBundle.loadString('assets/questions.json');
    final data = await json.decode(response);
    return List<CO2ComparisonItem>.from(
        data.map((item) => CO2ComparisonItem.fromJson(item)));
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
    CO2ComparisonItem future = items[(currentIndex + 2) % items.length];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildItemPanel(current, future, context, showCO2: true),
                _buildItemPanel(next, future, context, showCO2: false),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.black87,
            child: Center(
              child: Text(
                'Score: $score',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemPanel(CO2ComparisonItem item, CO2ComparisonItem futureItem,
      BuildContext context,
      {required bool showCO2}) {
    return Expanded(
      child: Container(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double containerWidth = constraints.maxWidth;
            return Stack(
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(-1.0, 0.0),
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  )),
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Transform.translate(
                              offset: Offset(containerWidth * 1, 0.0),
                              child: Image.asset(
                                futureItem.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.description,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      if (showCO2)
                        Text(
                          '${item.co2Impact.toStringAsFixed(2)} kg CO2',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                      if (!showCO2)
                        ElevatedButton(
                          onPressed: animationActive ? null : () =>
                                  evaluateAnswer(true, item.co2Impact),
                          child: Text('Higher'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                        ),
                      if (!showCO2)
                        ElevatedButton(
                          onPressed: animationActive ? null : () =>
                                  evaluateAnswer(false, item.co2Impact),
                          child: Text('Lower'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),

                      if (animationActive & !showCO2)
                        Text(
                          '${item.co2Impact.toStringAsFixed(2)} kg CO2',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void evaluateAnswer(bool higher, double nextImpact) {
    CO2ComparisonItem current = items[currentIndex];
    bool correct = (higher && nextImpact > current.co2Impact) ||
        (!higher && nextImpact < current.co2Impact);

    if (correct) {
      setState(() {
        animationActive = true; // Set animationActive to true immediately
      });

      // Delay the animation by 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          score++;
          _animationController.forward();
        });
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HigherLowerLossPage(
            finalScore: score,
            correctAnswer: nextImpact > items[currentIndex].co2Impact
                ? "Higher"
                : "Lower",
          ),
        ),
      );
    }
  }

  void evaluateNext() {
    setState(() {
      currentIndex = (currentIndex + 1) % items.length;
    });
  }
}