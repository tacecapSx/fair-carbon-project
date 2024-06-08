import 'dart:convert';
import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/higher_lower_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'custom_widgets.dart';
import 'dart:math';

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
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Choose a game mode", style: TextStyle(color: AppColors.whiteTextColor, fontSize: 36),),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HigherLowerPage(isDaily: true),),
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
                  child: const Text("Daily"),
                ),
                const SizedBox(height: 50,),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement( //push replacement to make sure the score reinitializes as 0
                      context,
                      MaterialPageRoute(builder: (context) => const HigherLowerPage(isDaily: false),),
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
                  child: const Text("Endless"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
