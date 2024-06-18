//Martin (the page displaying results of a higher/lower game)

import 'dart:convert';
import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/higher_lower_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'custom_widgets.dart';
import 'dart:math';

class HigherLowerLossPage extends StatefulWidget {
  const HigherLowerLossPage({super.key, required this.finalScore, required this.percentScore, required this.correctAnswer, required this.isDaily});

  final int finalScore;
  final double percentScore;
  final String correctAnswer;
  final bool isDaily;

  @override
  HigherLowerLossPageState createState() => HigherLowerLossPageState();
}

class HigherLowerLossPageState extends State<HigherLowerLossPage> {

  Future<String> getRandomFact() async {
    // fetch the json file with facts
    final String response = await rootBundle.loadString('assets/facts.json');

    // decode the json so it can be indexed
    final data = await json.decode(response);

    // index the text member of a random element in the fact list
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
          Container( // dark overlay on top of background image
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
                Text(
                  "${widget.isDaily && widget.finalScore == 10 ? "You completed the daily challenge! Go brag to your friends!" : "The correct answer was: ${widget.correctAnswer}!"}${widget.isDaily ? "\nTry again tomorrow!" : ""}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.whiteTextColor,
                    fontSize: 16,
                  ),
                ),
                //Oskar (Show percent score)
                if (!widget.isDaily)
                Transform.translate(
                  offset: const Offset(0, 20),
                  child: Text(
                    "You did better than ${widget.percentScore.floor()}% of players", 
                    style: const TextStyle(
                      color: AppColors.whiteTextColor, 
                      fontSize: 16
                    ),
                  ),
                ),
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
                    if(!widget.isDaily)
                    const SizedBox(width: 50,),
                    if(!widget.isDaily)
                    TextButton( // only allow the user to play again from the beginning if they were playing endless mode before
                      onPressed: () {
                        Navigator.pushReplacement( //push replacement to make sure the score reinitializes as 0
                          context,
                          MaterialPageRoute(builder: (context) => const HigherLowerPage(isDaily: false,),),
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
                        future: getRandomFact(), // fetch the random fact
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) { // while the future is resolving, show loading
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) { // if the future resolves successfully, display the fact
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
