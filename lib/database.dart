//Oskar (Database functions)

import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

Future<void> sendData(String path, double data) async {
  try {
    await _databaseReference
        .child(path)
        .set(data)
        .timeout(const Duration(seconds: 2));
  } catch (e) {
    // timeout, permission error, offline
  }
}


Future<void> sendDataList(String path, List<double> data) async {
  try {
    await _databaseReference
        .child(path)
        .set(data)
        .timeout(const Duration(seconds: 2));
  } catch (e) {
    // timeout, permission error, offline
  }
}


Future<double?> getData(String path) async {
  try {
    final databaseEvent = await _databaseReference
        .child(path)
        .once()
        .timeout(const Duration(seconds: 2));

    final dataSnapshot = databaseEvent.snapshot;

    if (dataSnapshot.value != null) {
      return (dataSnapshot.value as num).toDouble();
    }
  } catch (e) {
    // timeout, permission error, offline
  }

  return null;
}

Future<List<double>> getDataList(String path) async {
  try {
    final databaseEvent = await _databaseReference
        .child(path)
        .once()
        .timeout(const Duration(seconds: 2));

    final snapshot = databaseEvent.snapshot;
    final value = snapshot.value;

    if (value is List) {
      return value
          .whereType<num>()
          .map((e) => e.toDouble())
          .toList();
    }
  } catch (e) {
    // timeout, permission error, offline
  }

  return [];
}


void updateDataList(String path, double data) async{
    List<double> update = await getDataList(path);

    update.add(data);
    sendDataList(path, update);
}