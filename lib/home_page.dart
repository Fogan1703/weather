import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/app_icons.dart';
import 'package:weather/app_state_model.dart';
import 'package:weather/generated/l10n.dart';
import 'package:weather/locations_page.dart';
import 'package:weather/settings_page.dart';
import 'package:weather/string_extension.dart';
import 'package:weather/widgets/daily_forecast.dart';
import 'package:weather/widgets/hourly_forecast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateModel>(context);
    final localization = S.of(context);
    final locationNameText = Text(
      appState.getSelectedLocation.name,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF62B8F6),
                      Color(0xFF2C79C1),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const LocationsPage(
                                    isSearching: true,
                                  );
                                },
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const LocationsPage(
                                      isSearching: false,
                                    );
                                  },
                                ),
                              );
                            },
                            child: appState.getSelectedLocation.isCurrent
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      locationNameText,
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  )
                                : locationNameText,
                          ),
                        ),
                        PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              child: Text(
                                'Share',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const SettingsPage();
                                      },
                                    ),
                                  );
                                });
                              },
                              child: const Text(
                                'Settings',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Consumer<AppStateModel>(
                          builder: (context, appState, child) {
                            return Image.asset(
                              'assets/weather_icons/' +
                                  (appState.getSelectedLocation.currentWeather
                                          .isDay
                                      ? 'day'
                                      : 'night') +
                                  '/${appState.getSelectedLocation.currentWeather.iconId}.png',
                              width: 128,
                              fit: BoxFit.fitWidth,
                              color: Colors.white,
                              colorBlendMode: BlendMode.srcIn,
                            );
                          },
                        ),
                        Column(
                          children: [
                            const _DayAndDate(),
                            Consumer<AppStateModel>(
                              builder: (context, appState, child) {
                                return Text(
                                  appState.temperatureUnit
                                          .toNumberStringFromCelsius(appState
                                              .getSelectedLocation
                                              .currentWeather
                                              .temp) +
                                      '°',
                                  style: GoogleFonts.poppins(
                                    fontSize: 72,
                                  ),
                                );
                              },
                            ),
                            Text(
                              appState
                                  .getSelectedLocation.currentWeather.weather,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      height: 24,
                    ),
                    SizedBox(
                      height: 120,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _CurrentWeatherParam(
                                  icon:
                                      const Icon(AppIcons.carbon_location_current),
                                  value:
                                      '${appState.windSpeedUnit.toNumberStringFromKMH(appState.getSelectedLocation.currentWeather.windSpeed)} ${appState.windSpeedUnit.toLocalizedString(localization)}',
                                  name: localization.wind,
                                ),
                                _CurrentWeatherParam(
                                  icon:
                                      const Icon(AppIcons.fluent_weather_rain_24_regular),
                                  value:
                                      '${appState.getSelectedLocation.currentWeather.chanceOfRain}%',
                                  name: localization.chanceOfRain,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                _CurrentWeatherParam(
                                  icon: const Icon(
                                      AppIcons.fluent_temperature_24_regular),
                                  value:
                                      '${appState.atmosphericPressureUnit.toNumberStringFromMbar(appState.getSelectedLocation.currentWeather.pressure)} ${appState.atmosphericPressureUnit.toLocalizedString(localization)}',
                                  name: localization.pressure,
                                ),
                                _CurrentWeatherParam(
                                  icon: const Icon(AppIcons.ion_water_outline),
                                  value:
                                      '${appState.getSelectedLocation.currentWeather.humidity}%',
                                  name: localization.humidity,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color(0xFF2C79C1),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: _DayAndDate(
                      fontWeight: FontWeight.w600,
                      alignment: MainAxisAlignment.start,
                    ),
                  ),
                  HourlyForecast(
                    forecasts: appState.getSelectedLocation.hourlyWeather,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DailyForecast(
              forecasts: appState.getSelectedLocation.dailyWeather,
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentWeatherParam extends StatelessWidget {
  final Icon icon;
  final String value;
  final String name;

  const _CurrentWeatherParam({
    required this.icon,
    required this.value,
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          const SizedBox(width: 24),
          IconTheme(
            data: Theme.of(context).iconTheme.copyWith(
                  size: 32,
                ),
            child: icon,
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                ),
              ),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayAndDate extends StatelessWidget {
  final FontWeight fontWeight;
  final MainAxisAlignment alignment;

  const _DayAndDate({
    this.fontWeight = FontWeight.normal,
    this.alignment = MainAxisAlignment.center,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Text(
            DateFormat(DateFormat.WEEKDAY).format(now).upperCaseFirstLetter(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: fontWeight,
            ),
          ),
          const VerticalDivider(
            width: 24,
            thickness: 2,
          ),
          Text(
            DateFormat('MMM dd').format(now).upperCaseFirstLetter(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
