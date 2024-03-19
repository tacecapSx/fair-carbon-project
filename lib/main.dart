import 'package:carbon_footprint/custom_widgets.dart';
import 'questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'async_provider.dart';
import 'higher_lower_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AsyncProvider(),
      child: const MainApp(),
    ),
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
            ImageButtonWidget(text: "Footprint Calculator", imagePath: "assets/calculator.jpg", page: QuestionnairePage()),
            ImageButtonWidget(text: "Higher / Lower", imagePath: "assets/higherlowerpage.png", page: HigherLowerPage())
          ]
        ),
    );
  }
}
