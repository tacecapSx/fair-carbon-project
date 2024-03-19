import 'package:carbon_footprint/higher_lower_page.dart';
import 'package:carbon_footprint/questionnaire.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const HeaderWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/Logo.png'),
      ),
      title: const Text('FOOTPRINT CALCULATOR'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QuestionnairePage()));
            },
            child: const Text('Your footprint',
                style: TextStyle(color: Colors.black))),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HigherLowerPage()));
            },
            child: const Text('Higher/Lower',
                style: TextStyle(color: Colors.black))),
        TextButton(
            onPressed: () {},
            child: const Text('About', style: TextStyle(color: Colors.black))),
      ],
    );
  }
}
