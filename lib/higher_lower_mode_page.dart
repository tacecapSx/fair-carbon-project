//Martin (simple page to choose higher/lower gamemode)

import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/higher_lower_page.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class HigherLowerModePage extends StatefulWidget {
  const HigherLowerModePage({super.key});

  @override
  HigherLowerModePageState createState() => HigherLowerModePageState();
}

class HigherLowerModePageState extends State<HigherLowerModePage> {

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
          Container( // dark overlay on top of the background image
            color: Colors.black.withOpacity(0.65),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Choose a game mode", style: TextStyle(color: AppColors.whiteTextColor, fontSize: 28),),
                const SizedBox(height: 50,),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement( // daily mode chosen, pass true into the higher/lower page
                      context,
                      MaterialPageRoute(builder: (context) => const HigherLowerPage(isDaily: true),),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: AppColors.whiteTextColor,
                    foregroundColor: AppColors.blackTextColor,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Daily"),
                ),
                const SizedBox(height: 10,),
                const Text("10 unique new questions are presented every day. Try to complete them all!", style: TextStyle(fontSize: 14, color: AppColors.whiteTextColor),),
                const SizedBox(height: 50,),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement( // endless mode chosen, pass false into the higher/lower page
                      context,
                      MaterialPageRoute(builder: (context) => const HigherLowerPage(isDaily: false),),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: AppColors.whiteTextColor,
                    foregroundColor: AppColors.blackTextColor,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Endless"),
                ),
                const SizedBox(height: 10,),
                const Text("Play forever with randomly generated questions. Go for a high score!", style: TextStyle(fontSize: 14, color: AppColors.whiteTextColor),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
