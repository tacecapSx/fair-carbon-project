import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'higher_lower_end_page.dart';
import 'database.dart';
import 'co2_comparison_item.dart';

List<String> airports = ["Copenhagen","Paris","Tokyo","New York","Los Angeles","Sydney","London","Madrid"]; //sigurd, this is for flights.txt
//Sigurd = questions.json, flights.txt
class HigherLowerPage extends StatefulWidget {
  const HigherLowerPage({super.key, required this.isDaily});

  final bool isDaily;

  @override
  HigherLowerPageState createState() => HigherLowerPageState();
}

class HigherLowerPageState extends State<HigherLowerPage>
    with SingleTickerProviderStateMixin {
  List<CO2ComparisonItem> items = []; //initialising our values
  List<List<String>> flights= [];
  int currentIndex = 0;
  int score = 0;
  final int maxQuestions = 20; //unused?
  Random? random;
  bool animationActive = false;

  late AnimationController _animationController;

  @override
  void initState() { 
    super.initState();

    //create the Random to use based on if daily
    random = createRandom(widget.isDaily);

    loadFlights().then((loadedFlights) {
        flights = loadedFlights; //load the flights from flight.txt first
    });
    loadQuestions(widget.isDaily, flights, random!).then((loadedItems) {
      setState(() {
        items = loadedItems; //then load our comparisonitems from questions.json
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

  String getQuestionString(CO2ComparisonItem item) { //Sigurd
    if(item.id == 2) { //check if the question is the flight question, which needs city names in the string
      return "${item.preDescription} ${airports[item.flight1]} and ${airports[item.flight2]} (${item.amount.toString()} km)${item.postDescription}";
    }
    else{
      return "${item.preDescription} ${item.amount.toString()}${item.postDescription}"; //or return the simple description
    }
  }

  Future<List<List<String>>> loadFlights() async { //Sigurd
    final String flightString = 
      await rootBundle.loadString('assets/flights.txt'); //flights.txt is a 2d array seperated by spaces and \n representing the distance between cities i and j in km
      //we need to convert the text string that we import from flights.txt to a 2d array.
    List<String> flightArr = flightString.split('\n'); //split the array into rows
    
    for(String line in flightArr) {
      flights.add(line.split(' ')); //for every row, split into columns by spaces. its now a 2d array.
    }
    return flights; //return the 2d array
  }
    int getFlightAmount(CO2ComparisonItem item, List<List<String>> flights) { //Sigurd
    return (flights[item.flight1][item.flight2] as num).toInt(); //get the distance between the two flight destinations from our flights 2d array
  }

  Future<List<CO2ComparisonItem>> loadQuestions(bool isDaily, List<List<String>> flights, Random random) async {
    final String response =
        await rootBundle.loadString('assets/questions.json'); //Load our questions from the questions.json
    final data = await json.decode(response);
    final temp = List<CO2ComparisonItem>.from(
        data.map((item) => CO2ComparisonItem.fromJson(item, flights, airports, random))); //create a list of items
    for (CO2ComparisonItem co2item in temp) {
      co2item.shuffle(random); //randomize the values of all the items in our list
    }
    temp.shuffle(random); //shuffle the order of the list
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
      //Oskar (Design and Animation)
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

                    Container(
                      color: Colors.black.withOpacity(0.6),
                    ),

                    Center(
                      child: Transform.translate(
                        offset: Offset(containerWidth, 0), // Set your desired x and y offset here
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
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
                    if (!showCO2) const SizedBox(height: 20,),
                    if (!showCO2)
                      ElevatedButton(
                        onPressed: animationActive ? null : () =>
                          evaluateAnswer(true, item.co2Impact),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.fromLTRB(30,12,30,12)),
                        child: const Text('Higher', style: TextStyle(fontSize: 20, color: Colors.black),),
                      ),
                    if (!showCO2) const SizedBox(height: 20,),
                    if (!showCO2)
                      ElevatedButton(
                        onPressed: animationActive ? null : () =>
                                evaluateAnswer(false, item.co2Impact),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.fromLTRB(30,12,30,12)),
                        child: const Text('Lower', style: TextStyle(fontSize: 20, color: Colors.black),),
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

    //Oskar (Collect data from player)

    String dataCollectionPath = "HigherOrLower/PlayerCorrectness/${current.preDescription}${current.postDescription} -- ${next.preDescription}${next.postDescription}/${correct ? "Correct" : "Not correct"}";
    double dataCollectionAmount = await getData(dataCollectionPath);
    sendData(dataCollectionPath, dataCollectionAmount+1);

    if (correct) {
      // check if the player has finished the daily
      if (widget.isDaily && score + 1 == 10) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HigherLowerEndPage(
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

      //Oskar (save and get user scores)
      if (!widget.isDaily){
        List<double> databaseDataset = await getDataList('HigherOrLower/AllScores');
        databaseDataset.add(score as double);
        sendDataList('HigherOrLower/AllScores', databaseDataset);
        
        int dataLength = databaseDataset.length;

        int rank = databaseDataset.length + 1;
        for (double allScore in databaseDataset) {
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
          builder: (context) => HigherLowerEndPage(
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

  void evaluateNext() { // Martin
    setState(() {
      items[currentIndex].shuffle(random!); //set new random values for the just passed item

      // make sure we're shuffling things that aren't onscreen because of a wrap
      final int subListStart = currentIndex - (items.length - 3) < 0 ? 0 : currentIndex - (items.length - 3);

      List<CO2ComparisonItem> subList = items.sublist(subListStart, currentIndex + 1); // get the previous questions
      subList.shuffle(random!); // shuffle them

      for(int i = 0; i < subList.length; i++) { // ...and put the shuffled sublist into the items list.
        items[i + subListStart] = subList[i];
      }

      currentIndex = (currentIndex + 1) % items.length;
    });
  }
}