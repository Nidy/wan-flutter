// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `WanFlutter`
  String get appName {
    return Intl.message(
      'WanFlutter',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Blog`
  String get tabHome {
    return Intl.message(
      'Blog',
      name: 'tabHome',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get tabProject {
    return Intl.message(
      'Project',
      name: 'tabProject',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get tabAccounts {
    return Intl.message(
      'Accounts',
      name: 'tabAccounts',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get tabSystem {
    return Intl.message(
      'System',
      name: 'tabSystem',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get tabMine {
    return Intl.message(
      'Mine',
      name: 'tabMine',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}