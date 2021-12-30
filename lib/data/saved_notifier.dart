import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SavedNotifier with ChangeNotifier {
  //final List<Widget> movableItems = [];
  String _imageUrl = "";
  double _x = 0;
  double _y = 0;
  void imageSaved(String url, double x, double y) {
    _imageUrl = url;
    _x = x;
    _y = y;
    notifyListeners();
  }

  String get imageUrl => _imageUrl;
  double get x => _x;
  double get y => _y;
}
