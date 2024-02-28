import 'package:flutter/material.dart';

// Access fields and methods of this provider in a widget's build function by typing:
// final asyncProvider = Provider.of<AsyncProvider>(context, listen: false);
class AsyncProvider with ChangeNotifier {
  int activePage = 0;
}