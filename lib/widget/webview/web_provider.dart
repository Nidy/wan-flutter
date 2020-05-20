import 'package:flutter/material.dart';

class WebProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool state) {
    _isLoading = state;
    notifyListeners();
  }
}