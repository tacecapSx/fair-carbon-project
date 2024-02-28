import 'package:flutter/material.dart';

class HigherLowerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              'assets/forest_fire.jpg', // Path to the left image asset
              width: MediaQuery.of(context).size.width / 2, // Adjusting width to half of the screen width
              fit: BoxFit.contain, // Contain the image within its box
            ),
          ),
        ),
        Expanded( // Removed the extra 'x' character here
          child: Container(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/private_jet.jpg', // Path to the right image asset
              width: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.contain, // Contain the image within its box
            ),
          ),
        ),
      ],
    );
  }
}