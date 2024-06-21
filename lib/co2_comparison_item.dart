import 'dart:math';

class CO2ComparisonItem {
  final int id; // the unique id of the question
  final String preDescription; //the string before the randomized amount
  final String postDescription; //the string after the randomized amount
  final double eCO2; //the amount of equivalent CO2 pr amount
  final int minQuant; //the smallest possible amount
  final int maxQuant; //the largest possible ammount
  final String imagePath; //the image for the background
  final List<String> airports;
  int amount; //the amount, between minQuant and maxQuant, that gives co2impact when multipliplied with eCO2
  double co2Impact; //amount multiplied with eCO2
  List<List<String>> flights;
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
    required this.flights,
    required this.airports,
    this.flight1 = 0,
    this.flight2 = 0
  });

  void flightAmount() async{
    int tempInt = double.parse(flights[flight1][flight2]).toInt();
    amount = tempInt;
  }

  void shuffle() {
    if(id == 2) { //is flight question
      flight1 = Random().nextInt(airports.length);
      do {
        flight2 = Random().nextInt(airports.length);
      }
      while(flight1 == flight2);

      flightAmount();
    }
    else {
      amount = Random().nextInt(maxQuant - minQuant) + minQuant;
    }

    co2Impact = amount * eCO2;
  }

  factory CO2ComparisonItem.fromJson(Map<String, dynamic> json, List<List<String>> flights, List<String> airports, Random random) {
    return CO2ComparisonItem(
      id: json['id'],
      preDescription: json['preDescription'],
      postDescription: json['postDescription'],
      eCO2: (json['eCO2'] as num).toDouble(),
      minQuant: (json['minQuant'] as num).toInt(),
      maxQuant: (json['maxQuant'] as num).toInt(),
      imagePath: json['imagePath'],
      amount: random.nextInt((json['maxQuant'] as num).toInt()-(json['minQuant'] as num).toInt())+(json['minQuant'] as num).toInt(),
      airports: airports,
      co2Impact: 0,
      flights: flights,
      flight1: random.nextInt(airports.length),
      flight2: random.nextInt(airports.length)
    );
  }
}