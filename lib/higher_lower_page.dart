import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'higher_lower_loss_page.dart';
import 'package:firebase_database/firebase_database.dart';

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
    int tempInt = (flights[flight1][flight2] as num).toInt();
    amount = tempInt;
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
  HigherLowerPageState createState() => HigherLowerPageState();
}

class HigherLowerPageState extends State<HigherLowerPage>
    with SingleTickerProviderStateMixin {
  List<CO2ComparisonItem> items = [];
  List<List<String>> flights= [];
  int currentIndex = 0;
  int score = 0;
  final int maxQuestions = 20;
  bool animationActive = false;

  late AnimationController _animationController;

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  void sendData(String path, int data) {
    _databaseReference.child(path).set(data);
  }

  void sendDataList(String path, List<int> data) {
    _databaseReference.child(path).set(data);
  }

  Future<int> getData(String path) async {
    DatabaseEvent databaseEvent = await _databaseReference.child(path).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    if (dataSnapshot.value != null) {
      return dataSnapshot.value as int;
    }

    return 0;
  }

  Future<List<int>> getDataList(String path) async {
    List<int> dataList = [];
    DatabaseEvent databaseEvent = await _databaseReference.child(path).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    if (dataSnapshot.value != null) {
      List<dynamic> list = dataSnapshot.value as List<dynamic>;

      for (dynamic value in list) {
        dataList.add(value as int);
      }
    }
    
    return dataList;
  }

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
      duration: const Duration(milliseconds: 500),
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
      return "${item.preDescription} ${airports[item.flight1]} and ${airports[item.flight2]} (${item.amount.toString()} km)${item.postDescription}";
    }
    else{
      return item.preDescription+" "+item.amount.toString()+item.postDescription;
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
        appBar: AppBar(title: const Text("Loading questions...")),
        body: const Center(child: CircularProgressIndicator()),
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
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.black87,
            child: Center(
              child: Text(
                'Score: $score',
                style: const TextStyle(
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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(  
                      getQuestionString(item),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    if (showCO2)
                      Text(
                        '${item.co2Impact.toStringAsFixed(2)} kg CO2',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow),
                      ),
                    if (!showCO2)
                      ElevatedButton(
                        onPressed: animationActive ? null : () =>
                          evaluateAnswer(true, item.co2Impact),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text('Higher'),
                      ),
                    if (!showCO2)
                      ElevatedButton(
                        onPressed: animationActive ? null : () =>
                                evaluateAnswer(false, item.co2Impact),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Lower'),
                      ),

                    if (animationActive & !showCO2)
                      Text(
                        '${item.co2Impact.toStringAsFixed(2)} kg CO2',
                        style: const TextStyle(
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
    );
  }

  void evaluateAnswer(bool higher, double nextImpact) async {
    CO2ComparisonItem current = items[currentIndex];
    CO2ComparisonItem next = items[(currentIndex + 1) % items.length];

    bool correct = (higher && nextImpact > current.co2Impact) ||
        (!higher && nextImpact < current.co2Impact);

    //Collect data from player
    String dataCollectionPath = "HigherOrLower/PlayerCorrectness/" + current.preDescription + current.postDescription + " -- " + next.preDescription + next.postDescription
    + "/" + (correct ? "Correct" : "Not correct");
    int dataCollectionAmount = await getData(dataCollectionPath);
    sendData(dataCollectionPath, dataCollectionAmount+1);

    if (correct) {
      // check if the player has finished the daily
      if (widget.isDaily && score + 1 == 10) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HigherLowerLossPage(
              isDaily: widget.isDaily,
              finalScore: 10,
              percentScore: 0,
              correctAnswer: "",
            ),
          ),
        );
      }

      setState(() {
        animationActive = true;
      });

      // Delay the animation by 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          score++;
          _animationController.forward();
        });
      });
    } else {

      double scorePercent = 0;

      if (!widget.isDaily){
        List<int> databaseDataset = await getDataList('HigherOrLower/AllScores');
        databaseDataset.add(score);
        sendDataList('HigherOrLower/AllScores', databaseDataset);
        
        int dataLength = databaseDataset.length;

        int rank = databaseDataset.length + 1;
        for (int allScore in databaseDataset) {
          if (allScore >= score && rank > 1) {
            rank--;
          }
        }
        
        scorePercent = rank / dataLength * 100;
      }
      
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => HigherLowerLossPage(
            isDaily: widget.isDaily,
            finalScore: score,
            percentScore: scorePercent,
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