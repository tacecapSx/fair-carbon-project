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
    }, {
      'question': 'how many kilometers have you flown in the last year? ',
      'answers': [
        'more than 600 km',
        '500-600 km',
        '400-500 km',
        '300-400 km',
        '200-300 km',
        '100-200 km'
      ],
    },
    // Add more questions
  ];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questionnaire.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = null; // Reset the selected answer for the new question
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
        _selectedAnswer = null; // Reset the selected answer for the new question
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questionnaire[_currentQuestionIndex]['question'];
    final List<String> currentAnswers = _questionnaire[_currentQuestionIndex]['answers'];

    return Scaffold(
      appBar:AppBar(
  leading: Padding(
    padding: const EdgeInsets.all(8.0), 
    child: Image.asset('Images/Logo.png'),),
        title: const Text('FOOTPRINT CALCULATOR'),
        actions: [
          TextButton(onPressed: () {}, child: Text('Your footprint ', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)))),
          TextButton(onPressed: () {}, child: Text('Higher/Lower', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)))),
          TextButton(onPressed: () {}, child: Text('About', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)))),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questionnaire.length,
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              currentQuestion,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: currentAnswers.map((answer) {
                return ListTile(
                  title: Text(answer),
                  tileColor: _selectedAnswer == answer ? Color.fromARGB(136, 0, 0, 0) : null,
                  onTap: () {
                    setState(() {
                      _selectedAnswer = answer;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _previousQuestion,
                child: Text('BACK'),
              ),
              TextButton(
                onPressed: _nextQuestion,
                child: Text('NEXT QUESTION'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
