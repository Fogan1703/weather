// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Wind`
  String get wind {
    return Intl.message(
      'Wind',
      name: 'wind',
      desc: '',
      args: [],
    );
  }

  /// `Pressure`
  String get pressure {
    return Intl.message(
      'Pressure',
      name: 'pressure',
      desc: '',
      args: [],
    );
  }

  /// `Humidity`
  String get humidity {
    return Intl.message(
      'Humidity',
      name: 'humidity',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get now {
    return Intl.message(
      'Now',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `Chance of rain`
  String get chanceOfRain {
    return Intl.message(
      'Chance of rain',
      name: 'chanceOfRain',
      desc: '',
      args: [],
    );
  }

  /// `rain`
  String get rain {
    return Intl.message(
      'rain',
      name: 'rain',
      desc: '',
      args: [],
    );
  }

  /// `Forecast for 7 days`
  String get forecastFor7Day {
    return Intl.message(
      'Forecast for 7 days',
      name: 'forecastFor7Day',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `UNIT`
  String get unit {
    return Intl.message(
      'UNIT',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Temperature unit`
  String get temperatureUnit {
    return Intl.message(
      'Temperature unit',
      name: 'temperatureUnit',
      desc: '',
      args: [],
    );
  }

  /// `Wind speed unit`
  String get windSpeedUnit {
    return Intl.message(
      'Wind speed unit',
      name: 'windSpeedUnit',
      desc: '',
      args: [],
    );
  }

  /// `Atmospheric pressure unit`
  String get atmosphericPressureUnit {
    return Intl.message(
      'Atmospheric pressure unit',
      name: 'atmosphericPressureUnit',
      desc: '',
      args: [],
    );
  }

  /// `EXTRA`
  String get extra {
    return Intl.message(
      'EXTRA',
      name: 'extra',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `km/h`
  String get kmh {
    return Intl.message(
      'km/h',
      name: 'kmh',
      desc: '',
      args: [],
    );
  }

  /// `mil/h`
  String get milh {
    return Intl.message(
      'mil/h',
      name: 'milh',
      desc: '',
      args: [],
    );
  }

  /// `m/s`
  String get ms {
    return Intl.message(
      'm/s',
      name: 'ms',
      desc: '',
      args: [],
    );
  }

  /// `kn`
  String get kn {
    return Intl.message(
      'kn',
      name: 'kn',
      desc: '',
      args: [],
    );
  }

  /// `mbar`
  String get mbar {
    return Intl.message(
      'mbar',
      name: 'mbar',
      desc: '',
      args: [],
    );
  }

  /// `atm`
  String get atm {
    return Intl.message(
      'atm',
      name: 'atm',
      desc: '',
      args: [],
    );
  }

  /// `mmHg`
  String get mmHg {
    return Intl.message(
      'mmHg',
      name: 'mmHg',
      desc: '',
      args: [],
    );
  }

  /// `inHg`
  String get inHg {
    return Intl.message(
      'inHg',
      name: 'inHg',
      desc: '',
      args: [],
    );
  }

  /// `hPa`
  String get hPa {
    return Intl.message(
      'hPa',
      name: 'hPa',
      desc: '',
      args: [],
    );
  }

  /// `Search Your City`
  String get searchYourCity {
    return Intl.message(
      'Search Your City',
      name: 'searchYourCity',
      desc: '',
      args: [],
    );
  }

  /// `No results`
  String get noResults {
    return Intl.message(
      'No results',
      name: 'noResults',
      desc: '',
      args: [],
    );
  }

  /// `Manage location`
  String get manageLocation {
    return Intl.message(
      'Manage location',
      name: 'manageLocation',
      desc: '',
      args: [],
    );
  }

  /// `Search location`
  String get searchLocation {
    return Intl.message(
      'Search location',
      name: 'searchLocation',
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
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
