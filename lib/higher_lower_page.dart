import 'package:flutter/material.dart';

class HigherLowerPage extends StatelessWidget {
    const HigherLowerPage({super.key});

    @override
    Widget build(BuildContext context) {
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;

    return Container(

    //Display images
    padding: const EdgeInsets.only(top: 75.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            Expanded(
            child: AspectRatio(
                aspectRatio: 0.01,
                child: ClipRect(
                    child: OverflowBox(
                        alignment: Alignment.topLeft,
                            child: Image.asset(
                            'assets/forest_fire.jpg', // Path to the right image asset
                            fit: BoxFit.cover,
                        ),
                    ),
                ),
            ),
        ),
          Expanded(
            child: AspectRatio(
                aspectRatio: 0.01,
                child: ClipRect(
                    child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                        return Stack(
                        children: [
                            OverflowBox(
                            alignment: Alignment.topRight,
                            child: Image.asset(
                                'assets/apple_macbook_pro_16_2.jpg', // Path to the right image asset
                                fit: BoxFit.cover,
                                height: constraints.maxHeight,
                            ),
                            ),

                        //Higher or lower buttons
                        Positioned(
                            top: constraints.maxHeight / 2 - 80,
                            left: (windowWidth - constraints.maxWidth) / 2,
                            child: Column(
                                children: [
                                
                            //Higher button
                            SizedBox(
                                width: 150,
                                height: 60,
                                child: TextButton(
                                    onPressed: () {
                                        //   when button is pressed
                                    },

                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.white.withOpacity(0.6),
                                        ),

                                        side: MaterialStateProperty.all(const BorderSide(
                                        color: Colors.black,
                                        width: 4.0, 
                                        )),

                                        foregroundColor: MaterialStateProperty.all<Color>(
                                            Colors.green,
                                        ),
                                    ),
                                    child: const Text(
                                            'Higher ▲',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                            ),
                                        ),
                                    ),
                                ),
                            
                            //Lower button
                            const SizedBox(height: 20),
                            SizedBox(
                                width: 150,
                                height: 60, 
                                child: TextButton(
                                    onPressed: () {
                                        //   when button is pressed
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.white.withOpacity(0.6), 
                                        ),

                                        side: MaterialStateProperty.all(const BorderSide(
                                        color: Colors.black,
                                        width: 4.0, 
                                        )),

                                        foregroundColor: MaterialStateProperty.all<Color>(
                                            Colors.red,
                                        ),
                                    ),
                                    child: const Text(
                                        'Lower ▼',
                                        style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        ),
                                    ),
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
          ),
        ],
      ),
    );
  }
}