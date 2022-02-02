import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/app.dart';
import 'package:weather/app_state_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Opening adding location screen if the user has forbidden geolocation
  // TODO: Allow location tile in saved locations screen if the user has forbidden geolocation. Open settings if forbidden forever and open menu if not

  runApp(
    FutureBuilder<AppStateModel>(
      future: SharedPreferences.getInstance().then((prefs) {
        return AppStateModel.initialize(prefs);
      }),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: snapshot.hasData
              ? ChangeNotifierProvider<AppStateModel>.value(
                  value: snapshot.data!,
                  child: const App(),
                )
              : Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        );
      },
    ),
  );
}
