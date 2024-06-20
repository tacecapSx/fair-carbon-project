import 'package:carbon_footprint/questionnaire_page.dart';
import 'package:flutter/material.dart';
import 'higher_lower_mode_page.dart';
import 'about_page.dart';

import 'constants.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const HeaderWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            //go back to homepage
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/Logo.png'),
          ),
        ),
      ),
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            //go back to homepage
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: const Text('Fair Carbon Website'),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const QuestionnairePage()));
            },
            child: const Text('Your footprint',
                style: TextStyle(color: Colors.black))),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HigherLowerModePage()));
            },
            child: const Text('Higher/Lower',
                style: TextStyle(color: Colors.black))),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPageWidget()));
            },
            child: const Text('About', style: TextStyle(color: Colors.black))),
      ],
    );
  }
}

// Martin
// A widget for a generic button comprised of text overlayed on top of a darkened image that leads to another page.
class ImageButtonWidget extends StatefulWidget {
  const ImageButtonWidget(
      {super.key,
      required this.page,
      required this.text,
      required this.description,
      required this.imagePath});

  final Widget page;
  final String text;
  final String description;
  final String imagePath;

  @override
  ImageButtonWidgetState createState() => ImageButtonWidgetState();
}

class ImageButtonWidgetState extends State<ImageButtonWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: () {
            Navigator.push( //navigate to the widget's assigned page
              context,
              MaterialPageRoute(builder: (context) => widget.page),
            );
          },
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  OverflowBox(
                    alignment: Alignment.topRight,
                    child: Stack(
                      children: [
                        Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                          height: constraints.maxHeight,
                        ),
                        AnimatedContainer( //the dark overlay on top of the background image, animated to lighten when hovered.
                          duration: const Duration(milliseconds: 300),
                          color:
                              Colors.black.withOpacity(_isHovered ? 0.6 : 0.8),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text(
                          widget.text,
                          style: const TextStyle(
                            fontSize: 36,
                            color: AppColors.whiteTextColor
                          ),
                        ),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 200, 200, 200)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
