import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/generated/l10n.dart';
import 'package:weather/weather_api.dart';
import 'package:weather/weather_data.dart';

class AppStateModel extends ChangeNotifier {
  late final SharedPreferences prefs;
  late final List<LocationData> _locations;
  late final bool hasToOpenAddingLocationPage;

  late TemperatureUnit _temperatureUnit;
  late WindSpeedUnit _windSpeedUnit;
  late AtmosphericPressureUnit _atmosphericPressureUnit;
  late String _selectedLocationFullName;
  late bool _isLoadingLocations = false;

  late Future<AppStateModel> _initializing;

  AppStateModel() {
    _initializing = _init();
    _initializing.whenComplete(() {
      notifyListeners();
    });
  }

  Future<AppStateModel> _init() async {
    prefs = await SharedPreferences.getInstance();
    final List<String>? locationsFromPrefs = prefs.getStringList('locations');
    final List<LocationData> locations = [];

    final permission = await Geolocator.checkPermission();
    late final bool loadCurrentLocation;
    switch (permission) {
      case LocationPermission.denied:
        final permission = await Geolocator.requestPermission();
        switch (permission) {
          case LocationPermission.denied:
          case LocationPermission.deniedForever:
            loadCurrentLocation = false;
            break;
          case LocationPermission.whileInUse:
          case LocationPermission.always:
            loadCurrentLocation = true;
            break;
        }
        break;
      case LocationPermission.deniedForever:
        loadCurrentLocation = false;
        break;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        loadCurrentLocation = true;
        break;
    }

    if (loadCurrentLocation) {
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      ).then(
        (position) async {
          locations.add(
            await WeatherAPI.getCurrentLocationFromCoordinates(
              position.latitude,
              position.longitude,
            ),
          );
        },
        onError: (error) {},
      );
    }

    if (locationsFromPrefs != null) {
      for (final fullName in locationsFromPrefs) {
        locations.add(
          await WeatherAPI.getLocationFromFullName(fullName),
        );
      }
    } else {
      prefs.setStringList('locations', []);
    }

    temperatureUnit = _temperatureUnitFromPrefs(prefs);
    windSpeedUnit = _windSpeedUnitFromPrefs(prefs);
    atmosphericPressureUnit = _atmosphericPressureUnitFromPrefs(prefs);
    selectedLocationFullName = _getSelectedLocation(prefs);
    _locations = locations;
    hasToOpenAddingLocationPage = locations.isEmpty;

    return this;
  }

  Future<AppStateModel> get initializing => _initializing;

  LocationData get getSelectedLocation {
    if (_selectedLocationFullName.isEmpty) {
      try {
        return _locations.singleWhere((location) => location.isCurrent);
      } catch (e) {
        _selectedLocationFullName = _locations.first.fullName;
        prefs.setString('selectedLocation', _selectedLocationFullName);
        return _locations.first;
      }
    } else {
      return _locations
          .where((location) => location.isCurrent == false)
          .singleWhere(
            (location) => location.fullName == _selectedLocationFullName,
          );
    }
  }

  TemperatureUnit get temperatureUnit => _temperatureUnit;

  WindSpeedUnit get windSpeedUnit => _windSpeedUnit;

  AtmosphericPressureUnit get atmosphericPressureUnit =>
      _atmosphericPressureUnit;

  String? get selectedLocationFullName =>
      _selectedLocationFullName.isEmpty ? null : _selectedLocationFullName;

  List<LocationData> get locations => _locations;

  bool get isLoadingLocations => _isLoadingLocations;

  set temperatureUnit(TemperatureUnit value) {
    _temperatureUnit = value;
    notifyListeners();
    prefs.setString('temperatureUnit', value.toString());
  }

  set windSpeedUnit(WindSpeedUnit value) {
    _windSpeedUnit = value;
    notifyListeners();
    prefs.setString('windSpeedUnit', value.toString());
  }

  set atmosphericPressureUnit(AtmosphericPressureUnit value) {
    _atmosphericPressureUnit = value;
    notifyListeners();
    prefs.setString('atmosphericPressureUnit', value.toString());
  }

  set selectedLocationFullName(String? value) {
    _selectedLocationFullName = value ?? '';
    prefs.setString('selectedLocation', _selectedLocationFullName);
    notifyListeners();
  }

  void addLocationByFullName(String fullName) async {
    _isLoadingLocations = true;
    notifyListeners();
    _locations.add(await WeatherAPI.getLocationFromFullName(fullName));
    prefs.setStringList(
      'locations',
      _locations
          .where((location) => location.isCurrent == false)
          .map((location) => location.fullName)
          .toList(),
    );
    _isLoadingLocations = false;
    notifyListeners();
  }

  void removeByIndexes(Iterable<int> indexes) {
    for (final index in indexes) {
      _locations.removeAt(index);
    }
    if (_selectedLocationFullName != '') {
      bool hasSelected = false;
      for (final location in _locations) {
        if (location.fullName == _selectedLocationFullName) {
          hasSelected = true;
        }
      }
      if (hasSelected == false) {
        _selectedLocationFullName = '';
        prefs.setString('selectedLocation', '');
      }
    }
    prefs.setStringList(
      'locations',
      _locations.map((location) => location.fullName).toList(),
    );
    notifyListeners();
  }
}

String _getSelectedLocation(SharedPreferences prefs) {
  String? fromPrefs = prefs.getString('selectedLocation');
  if (fromPrefs != null) {
    return fromPrefs;
  } else {
    prefs.setString('selectedLocation', '');
    return '';
  }
}

enum TemperatureUnit {
  celsius,
  fahrenheit,
}

extension TemperatureUnitExtension on TemperatureUnit {
  String toLocalizedString() {
    switch (this) {
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
    }
  }

  String toNumberStringFromCelsius(int celsius) {
    switch (this) {
      case TemperatureUnit.celsius:
        return celsius.toString();
      case TemperatureUnit.fahrenheit:
        return ((celsius * 9 / 5) + 32).toStringAsFixed(0);
    }
  }
}

TemperatureUnit _temperatureUnitFromPrefs(SharedPreferences prefs) {
  final origin = prefs.getString('temperatureUnit');
  TemperatureUnit result = TemperatureUnit.celsius;

  if (origin != null) {
    for (var value in TemperatureUnit.values) {
      if (value.toString() == origin) {
        result = value;
        break;
      }
    }
  } else {
    prefs.setString('temperatureUnit', result.toString());
  }

  return result;
}

enum WindSpeedUnit {
  kmh,
  milh,
  ms,
  kn,
}

extension WindSpeedUnitExtension on WindSpeedUnit {
  String toLocalizedString(S localization) {
    switch (this) {
      case WindSpeedUnit.kmh:
        return localization.kmh;
      case WindSpeedUnit.milh:
        return localization.milh;
      case WindSpeedUnit.ms:
        return localization.ms;
      case WindSpeedUnit.kn:
        return localization.kn;
    }
  }

  String toNumberStringFromKMH(double kmh) {
    switch (this) {
      case WindSpeedUnit.kmh:
        return kmh.toStringAsFixed(1);
      case WindSpeedUnit.milh:
        return (kmh * 0.62138888888).toStringAsFixed(1);
      case WindSpeedUnit.ms:
        return (kmh / 3.6).toStringAsFixed(1);
      case WindSpeedUnit.kn:
        return (kmh * 0.53995666666).toStringAsFixed(1);
    }
  }
}

WindSpeedUnit _windSpeedUnitFromPrefs(SharedPreferences prefs) {
  final origin = prefs.getString('windSpeedUnit');
  WindSpeedUnit result = WindSpeedUnit.kmh;

  if (origin != null) {
    for (var value in WindSpeedUnit.values) {
      if (value.toString() == origin) {
        result = value;
        break;
      }
    }
  } else {
    prefs.setString('windSpeedUnit', result.toString());
  }

  return result;
}

enum AtmosphericPressureUnit {
  mbar,
  atm,
  mmHg,
  inHg,
  hPa,
}

extension AtmosphericPressureUnitExtension on AtmosphericPressureUnit {
  String toLocalizedString(S localization) {
    switch (this) {
      case AtmosphericPressureUnit.mbar:
        return localization.mbar;
      case AtmosphericPressureUnit.atm:
        return localization.atm;
      case AtmosphericPressureUnit.mmHg:
        return localization.mmHg;
      case AtmosphericPressureUnit.inHg:
        return localization.inHg;
      case AtmosphericPressureUnit.hPa:
        return localization.hPa;
    }
  }

  String toNumberStringFromMbar(int mbar) {
    switch (this) {
      case AtmosphericPressureUnit.mbar:
        return mbar.toString();
      case AtmosphericPressureUnit.atm:
        return (mbar * 0.0009869232667160128).toStringAsFixed(3);
      case AtmosphericPressureUnit.mmHg:
        return (mbar * 0.75006156130264).toStringAsFixed(0);
      case AtmosphericPressureUnit.inHg:
        return (mbar * 0.029529983071445).toStringAsFixed(2);
      case AtmosphericPressureUnit.hPa:
        return mbar.toString();
    }
  }
}

AtmosphericPressureUnit _atmosphericPressureUnitFromPrefs(
    SharedPreferences prefs) {
  final origin = prefs.getString('atmosphericPressureUnit');
  AtmosphericPressureUnit result = AtmosphericPressureUnit.mbar;

  if (origin != null) {
    for (var value in AtmosphericPressureUnit.values) {
      if (value.toString() == origin) {
        result = value;
        break;
      }
    }
  } else {
    prefs.setString('atmosphericPressureUnit', result.toString());
  }

  return result;
}
