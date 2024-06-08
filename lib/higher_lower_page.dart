import 'dart:convert';
import 'dart:math';
import 'package:carbon_footprint/co2_comparison_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'higher_lower_loss_page.dart';

//Copenhagen;Paris;Tokyo;New York;Los Angeles;Sydney;London;Madrid
List<String> airports = ["Copenhagen","Paris","Tokyo","New York","Los Angeles","Sydney","London","Madrid"];
List<List<String>> flights = [];
class CO2ComparisonItem {
  final int id; // the unique id of the question
  final String preDescription; //the string before the randomized amount
  final String postDescription; //the string after the randomized amount
  final double eCO2; //the amount of equivalent CO2 pr amount
  final int minQuant; //the smallest possible amount
  final int maxQuant; //the largest possible ammount
  final String imagePath; //the image for the background
  int amount; //the amount, between minQuant and maxQuant, that gives co2impact when multipliplied with eCO2
  double co2Impact; //amount multiplied with eCO2
  int flight1;
  int flight2;

  CO2ComparisonItem({
    required this.id,
    required this.preDescription,
    required this.postDescription,
    required this.eCO2,
    required this.minQuant,
    required this.maxQuant,
    required this.imagePath,
    this.amount = 0,
    required this.co2Impact,
    this.flight1 = 0,
    this.flight2 = 0
  });
  void flightAmount() async{
    int tempInt = (flights[this.flight1][this.flight2] as num).toInt();
    this.amount = tempInt;
    //if(tempInt != null){
     // this.amount = 1;
    //}
  }
  factory CO2ComparisonItem.fromJson(Map<String, dynamic> json, Random random) {
    return CO2ComparisonItem(
      id: json['id'],
      preDescription: json['preDescription'],
      postDescription: json['postDescription'],
      eCO2: (json['eCO2'] as num).toDouble(),
      minQuant: (json['minQuant'] as num).toInt(),
      maxQuant: (json['maxQuant'] as num).toInt(),
      imagePath: json['imagePath'],
      amount: random.nextInt((json['maxQuant'] as num).toInt()-(json['minQuant'] as num).toInt())+(json['minQuant'] as num).toInt(),
      co2Impact: 0,
      flight1: random.nextInt(airports.length),
      flight2: random.nextInt(airports.length)
    );
  }
}

class HigherLowerPage extends StatefulWidget {
  const HigherLowerPage({super.key, required this.isDaily});

  final bool isDaily;

  @override
  _HigherLowerPageState createState() => _HigherLowerPageState();
}

class _HigherLowerPageState extends State<HigherLowerPage>
    with SingleTickerProviderStateMixin {
  List<CO2ComparisonItem> items = [];
  List<List<String>> flights= [];
  int currentIndex = 0;
  int score = 0;
  final int maxQuestions = 20;
  bool animationActive = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    loadFlights().then((loadedFlights) {
      setState(() {
        flights = loadedFlights;
        
      });
      
    });
    loadQuestions(widget.isDaily).then((loadedItems) {
      setState(() {
        items = loadedItems;
      });
    });
    

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        setState(() {
          animationActive = false;
        });
        evaluateNext();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String getQuestionString(CO2ComparisonItem item) {
    if(item.id == 2) {
      return item.preDescription+airports[item.flight1]+" and "+airports[item.flight2]+" ("+item.amount.toString()+" km) "+item.postDescription;
    }
    else{
      return item.preDescription+item.amount.toString()+item.postDescription;
    }
  }

  Future<List<List<String>>> loadFlights() async {
    final String flightString = 
      await rootBundle.loadString('assets/flights.txt');
      
    List<String> flightArr = flightString.split('\n');
    
    for(String line in flightArr) {
      flights.add(line.split(' '));
    }
    return flights;
  }
    int getFlightAmount(CO2ComparisonItem item, List<List<String>> flights) {
    return (flights[item.flight1][item.flight2] as num).toInt();
  }

  Future<List<CO2ComparisonItem>> loadQuestions(isDaily) async {
    //create the Random to use based on if daily
    Random random = createRandom(isDaily);

    final String response =
        await rootBundle.loadString('assets/questions.json');
    final data = await json.decode(response);
    final temp = List<CO2ComparisonItem>.from(
        data.map((item) => CO2ComparisonItem.fromJson(item, random)));
    for (CO2ComparisonItem tempitem in temp) {
      if(tempitem.id == 2){
        while(tempitem.flight1 == tempitem.flight2){
          tempitem.flight2 = random.nextInt(airports.length);
        }
        //int tempAmount = getFlightAmount(tempitem,flights);
        
        tempitem.flightAmount();
        //tempitem.amount = 1;
        tempitem.co2Impact = tempitem.amount*tempitem.eCO2;
        
        
      }
      else{
      tempitem.co2Impact = tempitem.amount*tempitem.eCO2;
    }
    }
    temp.shuffle(random);
    return temp;
  }

  Random createRandom(isDaily) {
    if(isDaily) {
      DateTime now = DateTime.now();
      
      // hash the time to a seed
      int seed = now.year * 10000 + now.month * 100 + now.day;

      return Random(seed);
    }
    
    return Random();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading questions...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    CO2ComparisonItem current = items[currentIndex];
    CO2ComparisonItem next = items[(currentIndex + 1) % items.length];
    CO2ComparisonItem future = items[(currentIndex + 2) % items.length];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildItemPanel(current, future, context, showCO2: true),
                _buildItemPanel(next, future, context, showCO2: false),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.black87,
            child: Center(
              child: Text(
                'Score: $score',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemPanel(CO2ComparisonItem item, CO2ComparisonItem futureItem,
      BuildContext context,
      {required bool showCO2}) {
    return Expanded(
      child: Container(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double containerWidth = constraints.maxWidth;
            return Stack(
              children: [
                
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(-1.0, 0.0),
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  )),
                  child: Container(
                    child: Stack(
                      children: [
                        
                        Positioned.fill(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                  color: Colors.black.withOpacity(0.6),
                ),
                        Positioned.fill(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Transform.translate(
                              offset: Offset(containerWidth * 1, 0.0),
                              child: Image.asset(
                                futureItem.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(  
                            getQuestionString(item),
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      if (showCO2)
                        Text(
                          '${item.co2Impact.toStringAsFixed(2)} kg CO2',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                      if (!showCO2)
                        ElevatedButton(
                          onPressed: animationActive ? null : () =>
                                  evaluateAnswer(true, item.co2Impact),
                          child: Text('Higher'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                        ),
                      if (!showCO2)
                        ElevatedButton(
                          onPressed: animationActive ? null : () =>
                                  evaluateAnswer(false, item.co2Impact),
                          child: Text('Lower'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),

                      if (animationActive & !showCO2)
                        Text(
                          '${item.co2Impact.toStringAsFixed(2)} kg CO2',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void evaluateAnswer(bool higher, double nextImpact) {
    CO2ComparisonItem current = items[currentIndex];
    bool correct = (higher && nextImpact > current.co2Impact) ||
        (!higher && nextImpact < current.co2Impact);

    if (correct) {
      // check if the player has finished the daily
      if(widget.isDaily && score + 1 == 10) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HigherLowerLossPage(
              isDaily: widget.isDaily,
              finalScore: 10,
              correctAnswer: ""
            ),
          ),
        );
      }

      setState(() {
        animationActive = true; // Set animationActive to true immediately
      });

      // Delay the animation by 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          score++;
          _animationController.forward();
        });
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HigherLowerLossPage(
            isDaily: widget.isDaily,
            finalScore: score,
            correctAnswer: nextImpact > items[currentIndex].co2Impact
                ? "Higher"
                : "Lower",
          ),
        ),
      );
    }
  }

  void evaluateNext() {
    setState(() {
      currentIndex = (currentIndex + 1) % items.length;
    });
  }
}