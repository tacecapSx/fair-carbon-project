import 'dart:convert';
import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/higher_lower_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'custom_widgets.dart';
import 'dart:math';

class HigherLowerLossPage extends StatefulWidget {
  const HigherLowerLossPage({super.key, required this.finalScore, required this.correctAnswer});

  final int finalScore;
  final String correctAnswer;

  @override
  HigherLowerLossPageState createState() => HigherLowerLossPageState();
}

class HigherLowerLossPageState extends State<HigherLowerLossPage> {

  Future<String> getRandomFact() async {
    final String response = await rootBundle.loadString('assets/facts.json');
    final data = await json.decode(response);
    return data[Random().nextInt(data.length)]["text"];
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: const HeaderWidget(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/train.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Final Score:", style: TextStyle(color: AppColors.whiteTextColor, fontSize: 24),),
                Text(
                  widget.finalScore.toString(),
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 36,
                  ),
                ),
                Text("The correct answer was: ${widget.correctAnswer}!", style: const TextStyle(color: AppColors.whiteTextColor, fontSize: 16),),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePageWidget(),),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.whiteTextColor,
                        foregroundColor: AppColors.blackTextColor,
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                                            child: const Text("Back to home"),
                    ),
                    const SizedBox(width: 50,),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement( //push replacement to make sure the score reinitializes as 0
                          context,
                          MaterialPageRoute(builder: (context) => const HigherLowerPage(),),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.whiteTextColor,
                        foregroundColor: AppColors.blackTextColor,
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text("Play again"),
                    ),
                  ],
                ),
                const SizedBox(height: 50,),
                SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("A random fact:", style: TextStyle(color: AppColors.whiteTextColor, fontSize: 20),),
                      const SizedBox(height: 12,),
                      FutureBuilder<String>(
                        future: getRandomFact(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            return Center(child: Text(snapshot.data!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.whiteTextColor, fontSize: 16),));
                          } else {
                            return const Center(child: Text('No fact could be found.', style: TextStyle(color: AppColors.whiteTextColor, fontSize: 16),));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
