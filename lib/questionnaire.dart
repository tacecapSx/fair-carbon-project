import 'package:flutter/material.dart';

import 'custom_widgets.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({Key? key}) : super(key: key);

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final List<Map<String, String>> _questionnaire = [
    {
      'question': 'How would you best describe your diet?',
    },
    {
      'question': 'How many kilometers have you flown in the last year?',
    },
  ];

  int _currentQuestionIndex = 0;
  final TextEditingController _answerController = TextEditingController();

  void _nextQuestion() {
    if (_currentQuestionIndex < _questionnaire.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.clear();
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _answerController.clear();
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questionnaire[_currentQuestionIndex]['question'] ??
        'No question available';

    return Scaffold(
      appBar: const HeaderWidget(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questionnaire.length,
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    currentQuestion,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      hintText: "Enter your answer here",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _previousQuestion,
                      child: const Text('BACK',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: _nextQuestion,
                      child: const Text('NEXT QUESTION',
                          style: TextStyle(color: Colors.white)),
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
