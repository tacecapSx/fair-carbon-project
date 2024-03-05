import 'questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'async_provider.dart';
import 'constants.dart';

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
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuestionnairePage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.secondaryColor),
                overlayColor: MaterialStateColor.resolveWith((states) => AppColors.primaryColor)
              ),
              child: const Text(
                "My Footprint",
                style: TextStyle(color: AppColors.whiteTextColor, fontSize: 32)
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HigherLowerPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.secondaryColor),
                overlayColor: MaterialStateColor.resolveWith((states) => AppColors.primaryColor)
              ),
              child: const Text(
                "Higher / Lower",
                style: TextStyle(color: AppColors.whiteTextColor, fontSize: 32)
              ),
            ),
          ]
        ),
      ),
    );
  }
}
