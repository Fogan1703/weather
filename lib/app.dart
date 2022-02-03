import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/app_state_model.dart';
import 'package:weather/generated/l10n.dart';
import 'package:weather/home_page.dart';
import 'package:weather/locations_page.dart';

class App extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        dividerColor: Colors.white,
        textTheme: const TextTheme(
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
        ),
      ),
      home: FutureBuilder<AppStateModel>(
        future: SharedPreferences.getInstance().then((prefs) {
          return AppStateModel.initialize(prefs);
        }),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: snapshot.hasData
                ? ChangeNotifierProvider<AppStateModel>.value(
                    value: snapshot.data!,
                    builder: (context, child) {
                      if (Provider.of<AppStateModel>(context)
                          .isFirstLaunchAndNoCurrentLocation) {
                        return const LocationsPage(
                          isSearching: true,
                          hasToAddLocation: true,
                        );
                      } else {
                        return const HomePage();
                      }
                    },
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
}
