import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/app_state_model.dart';
import 'package:weather/generated/l10n.dart';
import 'package:weather/weather_data.dart';

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> forecasts;

  const HourlyForecast({
    required this.forecasts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    final appState = Provider.of<AppStateModel>(context);

    return SizedBox(
      height: 110,
      child: ListView.builder(
        itemCount: forecasts.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          final forecast = forecasts[index];
          return SizedBox(
            width: 68,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 4,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    index == 0
                        ? localizations.now
                        : DateFormat('HH:mm').format(forecast.time),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/weather_icons/' +
                        (forecast.isDay ? 'day' : 'night') +
                        '/${forecast.iconId}.png',
                    height: 24,
                    fit: BoxFit.fitHeight,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                  Text(
                    appState.temperatureUnit
                            .toNumberStringFromCelsius(forecast.temp) +
                        '°',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${forecast.chanceOfRain.toString()}% ${localizations.rain}',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
