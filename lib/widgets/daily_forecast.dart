import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/app_state_model.dart';
import 'package:weather/generated/l10n.dart';
import 'package:weather/weather_data.dart';
import 'package:weather/string_extension.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyWeather> forecasts;

  const DailyForecast({
    Key? key,
    required this.forecasts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    return Expanded(
      child: Container(
        color: const Color(0xFF2C79C1),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                right: 16,
                bottom: 8,
              ),
              child: Text(
                localizations.forecastFor7Day,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: forecasts.length,
                itemBuilder: (context, index) {
                  final forecast = forecasts[index];
                  final appState = Provider.of<AppStateModel>(context);

                  return SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        top: 0,
                        right: 16,
                        bottom: 0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat('E')
                                  .format(forecast.time)
                                  .upperCaseFirstLetter(),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/weather_icons/' +
                                      (appState.getSelectedLocation.currentWeather
                                          .isDay
                                          ? 'day'
                                          : 'night') +
                                      '/${appState.getSelectedLocation.currentWeather.iconId}.png',
                                  width: 24,
                                  fit: BoxFit.fitWidth,
                                  color: Colors.white,
                                  colorBlendMode: BlendMode.srcIn,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${forecast.chanceOfRain}% ${localizations.rain}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 64,
                                child: Text(
                                  '${appState.temperatureUnit.toNumberStringFromCelsius(forecast.minTemp)}°',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Text(
                                '/',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                width: 32,
                                child: Text(
                                  '${appState.temperatureUnit.toNumberStringFromCelsius(forecast.maxTemp)}°',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
