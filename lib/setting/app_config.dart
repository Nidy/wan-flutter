import 'package:flutter/material.dart';

enum AppLocale {
  en,
  zhCN,
}

class AppConfig with ChangeNotifier {

  Locale get currLocale => _locale;
  Locale _locale = Locale('zh','CN');

  ThemeData get themeData => _themeData;
  ThemeData _themeData = ThemeData(
    primarySwatch: Colors.deepPurple,
    primaryColor: Colors.deepPurple[800],
    accentColor: Colors.deepPurple[650],
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

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