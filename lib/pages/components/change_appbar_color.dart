import 'package:flutter/material.dart';

class AppBarColorProvider with ChangeNotifier {
  Color _appBarColor = Colors.transparent;

  Color get appBarColor => _appBarColor;

  void updateColor(Color color) {
    _appBarColor = color;
    notifyListeners();  
  }
}
