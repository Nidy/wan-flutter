import 'package:flutter/material.dart';

enum AppLocale {
  en,
  zhCN,
}

class AppConfig with ChangeNotifier {

  Locale get currLocale => _locale;
  Locale _locale = Locale('zh','CN');

  void changeLanguage(AppLocale locale) {
    switch (locale) {
      case AppLocale.en:
        _locale = Locale('en');
        break;
      case AppLocale.zhCN:
        _locale = Locale('zh', 'CN');
        break;
    }
    notifyListeners();
  }
}