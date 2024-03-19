import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'custom_widgets.dart';

void sendDataToFirebase() {
  // Get a reference to the database
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  // Set data to a specific location in the database
  databaseReference.child('Testing message').push().set({
    'message': 'Testing database',
  }).catchError((error) {
    print('Failed to send data to Firebase: $error');
  });
}

class HigherLowerPage extends StatelessWidget {
    const HigherLowerPage({super.key});

    @override
    Widget build(BuildContext context) {
    //double windowHeight = MediaQuery.of(context).size.height;
    //double windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      //Display images
      appBar: const HeaderWidget(),
      body: Row(
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
                    Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            
                        //Higher button
                        SizedBox(
                            width: 150,
                            height: 60,
                            child: TextButton(
                                onPressed: () {
                                    //   when button is pressed
                                    sendDataToFirebase();
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
        ],
      ),
    );
  }
}