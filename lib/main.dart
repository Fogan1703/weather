import 'package:flutter/material.dart';
import 'package:weather/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Opening adding location screen if the user has forbidden geolocation
  // TODO: Allow location tile in saved locations screen if the user has forbidden geolocation. Open settings if forbidden forever and open menu if not

  runApp(const App());
}
