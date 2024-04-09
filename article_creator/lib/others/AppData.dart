import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  

  void forceNotify() {
    notifyListeners();
  }
}