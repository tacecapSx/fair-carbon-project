// Martin (website homepage)

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:carbon_footprint/custom_widgets.dart';
import 'questionnaire_page.dart';
import 'package:flutter/material.dart';
import 'higher_lower_mode_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fair Carbon Footprint Website',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => HomePageWidgetState();
}

class HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HeaderWidget(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ImageButtonWidget(text: "Footprint Calculator", description: "Model your carbon footprint!", imagePath: "assets/calculator.jpg", page: QuestionnairePage()),
            ImageButtonWidget(text: "Higher / Lower", description: "Test your knowledge!", imagePath: "assets/higherlowerpage.png", page: HigherLowerModePage())
          ]
        ),
    );
  }
}
