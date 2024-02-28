import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CO2 Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: QuestionnairePage(),
    );
  }
}

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final List<Map<String, dynamic>> _questionnaire = [
    {
      'question': 'How would you best describe your diet?',
      'answers': [
        'Meat in every meal',
        'Meat in some meals',
        'No beef',
        'Meat very rarely',
        'Vegetarian',
        'Vegan'
      ],
    },
    {
      'question': 'How many kilometers have you flown in the last year?',
      'answers': [
        'More than 600 km',
        '500-600 km',
        '400-500 km',
        '300-400 km',
        '200-300 km',
        '100-200 km'
      ],
    },
    // ... Add more questions here if needed
  ];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questionnaire.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
        _selectedAnswer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questionnaire[_currentQuestionIndex]['question'];
    final List<String> currentAnswers = _questionnaire[_currentQuestionIndex]['answers'];

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('images/logo.png'),
        ),
        title: const Text('FOOTPRINT CALCULATOR'),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Your footprint', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('Higher/Lower', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('About', style: TextStyle(color: Colors.black))),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'), // Replace with your actual path to the background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black.withOpacity(0.6), // Semi-transparent overlay for text readability
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questionnaire.length,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    currentQuestion,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentAnswers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: _selectedAnswer == currentAnswers[index] ? Colors.blue[700] : Colors.white,
                        child: ListTile(
                          title: Text(
                            currentAnswers[index],
                            textAlign: TextAlign.center, // Center the text
                            style: TextStyle(color: _selectedAnswer == currentAnswers[index] ? Colors.white : Colors.black),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedAnswer = currentAnswers[index];
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _previousQuestion,
                      child: Text('BACK', style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: _nextQuestion,
                      child: Text('NEXT QUESTION', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
