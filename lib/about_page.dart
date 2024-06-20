//Martin (a simple about page)

import 'dart:math';

import 'package:carbon_footprint/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class AboutPageWidget extends StatelessWidget {
  const AboutPageWidget({super.key});

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
            color: Colors.black.withOpacity(0.8),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: min(700, MediaQuery.of(context).size.width),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 10,),
                    Image.asset(
                      "assets/Logo.png",
                      width: min(160, MediaQuery.of(context).size.width/3),
                    ),
                    const SizedBox(height: 30,),
                    const Text(
                      "This website is designed to be a fun way to educate yourself about CO2 emissions, as well as model your own carbon footprint. It was made by Christian Rumle Kjær Ulsø [s214923], Martin Handest [s224755], Oskar William Ulrich Holland [s224768] and Sigurd Fajstrup Jørgensen [s224760] for the course 02122 Software Technology Project in collaboration with Fair Carbon Footprint.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: AppColors.whiteTextColor, fontSize: 18),
                    ),
                    const SizedBox(height: 100,),
                    const Text(
                      "Data pertaining to usage of the website is collected and will be used for the betterment of the climate, and reducing CO2 emissions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color.fromARGB(255, 200, 200, 200), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}