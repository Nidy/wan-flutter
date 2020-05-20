import 'package:flutter/material.dart';

class WebModel with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool state) {
    _isLoading = state;
    notifyListeners();
  }
}