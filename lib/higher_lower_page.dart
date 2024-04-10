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

class HigherLowerPage extends StatefulWidget {
  const HigherLowerPage({Key? key}) : super(key: key);

  @override
  _HigherLowerPageState createState() => _HigherLowerPageState();
}

void animatePage(AnimationController _controller){
  if (_controller.status == AnimationStatus.completed) {
    _controller.reverse();
  } else {
    _controller.forward();
  }
}

class _HigherLowerPageState extends State<HigherLowerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  double windowWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;

    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: Offset(windowWidth / 2, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    return Scaffold(
  appBar: const HeaderWidget(),
  body: AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {
      return Stack(
        children: [
          Positioned(
            left: 0,
            child: Image.asset(
              'assets/private_jet.jpg',
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          Transform.translate(
            offset: _animation.value,
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
                          'assets/forest_fire.jpg',
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
                              'assets/apple_macbook_pro_16_2.jpg',
                              fit: BoxFit.cover,
                              height: constraints.maxHeight,
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 60,
                                  child: TextButton(
                                    onPressed: () {
                                      sendDataToFirebase();
                                      if (_controller.status != AnimationStatus.forward &&
                                          _controller.status != AnimationStatus.completed) {
                                        _controller.forward();
                                      } else {
                                        _controller.reverse();
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                        Colors.white.withOpacity(0.6),
                                      ),
                                      side: MaterialStateProperty.all(
                                        const BorderSide(
                                          color: Colors.black,
                                          width: 4.0,
                                        ),
                                      ),
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
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 170,
                                  height: 60,
                                  child: TextButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                        Colors.white.withOpacity(0.6),
                                      ),
                                      side: MaterialStateProperty.all(
                                        const BorderSide(
                                          color: Colors.black,
                                          width: 4.0,
                                        ),
                                      ),
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
          ),
        ],
      );
    },
  ),
);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}