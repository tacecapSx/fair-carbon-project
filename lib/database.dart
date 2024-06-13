//Oskar (Database functions)

import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

void sendData(String path, double data) {
    _databaseReference.child(path).set(data);
}

void sendDataList(String path, List<double> data) {
    _databaseReference.child(path).set(data);
}

Future<double> getData(String path) async {
    DatabaseEvent databaseEvent = await _databaseReference.child(path).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    if (dataSnapshot.value != null) {
        return dataSnapshot.value as double;
    }

    return 0;
}

Future<List<double>> getDataList(String path) async {
    List<double> dataList = [];
    DatabaseEvent databaseEvent = await _databaseReference.child(path).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;
    if (dataSnapshot.value != null) {
        List<dynamic> list = dataSnapshot.value as List<dynamic>;

        for (dynamic value in list) {
        dataList.add(value as double);
        }
    }

    return dataList;
}

void updateDataList(String path, double data) async{
    List<double> update = await getDataList(path);
    update.add(data);
    sendDataList(path, update);
}