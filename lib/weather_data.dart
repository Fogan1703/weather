import 'package:weather/string_extension.dart';

class LocationData {
  final bool isCurrent;
  final String name;
  final String fullName;
  final CurrentWeather currentWeather;
  final List<HourlyWeather> hourlyWeather;
  final List<DailyWeather> dailyWeather;

  LocationData({
    required Map<String, dynamic> map,
    required this.isCurrent,
    required this.fullName,
  })  : name = fullName.split(', ').first,
        currentWeather = CurrentWeather.fromMap(
          map['current'],
          chanceOfRain: List.of(
            map['forecast']['forecastday'],
          ).first['hour'].first['chance_of_rain'],
        ),
        hourlyWeather = List.of(map['forecast']['forecastday'])
            .map((day) => day['hour'])
            .expand((x) => x)
            .map((hour) => HourlyWeather.fromMap(hour))
            .toList()
            .sublist(0, 24),
        dailyWeather = List.of(map['forecast']['forecastday'])
            .map((day) => DailyWeather.fromMap(day))
            .toList();
}

class CurrentWeather {
  final int temp;
  final double windSpeed;
  final int chanceOfRain;
  final int pressure;
  final int humidity;
  final String weather;
  final int iconId;
  final bool isDay;

  CurrentWeather({
    required this.temp,
    required this.windSpeed,
    required this.chanceOfRain,
    required this.pressure,
    required this.humidity,
    required this.weather,
    required this.iconId,
    required this.isDay,
  });

  CurrentWeather.fromMap(
    Map<String, dynamic> map, {
    required this.chanceOfRain,
  })  : temp = map['temp_c'].toInt(),
        windSpeed = map['wind_kph'].toDouble(),
        pressure = map['pressure_mb'].toInt(),
        humidity = map['humidity'],
        weather = (map['condition']['text'] as String).upperCaseFirstLetter(),
        iconId = int.parse(map['condition']['icon'].substring(
            map['condition']['icon'].length - 7,
            map['condition']['icon'].length - 4)),
        isDay = map['is_day'] == 1;
}

class DailyWeather {
  final DateTime time;
  final int chanceOfRain;
  final int minTemp;
  final int maxTemp;
  final int iconId;

  DailyWeather({
    required this.time,
    required this.chanceOfRain,
    required this.minTemp,
    required this.maxTemp,
    required this.iconId,
  });

  DailyWeather.fromMap(Map<String, dynamic> map)
      : time = DateTime.fromMillisecondsSinceEpoch(map['date_epoch'] * 1000),
        chanceOfRain = map['day']['daily_chance_of_rain'],
        minTemp = map['day']['mintemp_c'].toInt(),
        maxTemp = map['day']['maxtemp_c'].toInt(),
        iconId = int.parse(map['day']['condition']['icon'].substring(
            map['day']['condition']['icon'].length - 7,
            map['day']['condition']['icon'].length - 4));
}

class HourlyWeather {
  final DateTime time;
  final int chanceOfRain;
  final int temp;
  final int iconId;
  final bool isDay;

  HourlyWeather({
    required this.time,
    required this.chanceOfRain,
    required this.temp,
    required this.iconId,
    required this.isDay,
  });

  HourlyWeather.fromMap(Map<String, dynamic> map)
      : time = DateTime.fromMillisecondsSinceEpoch(map['time_epoch'] * 1000),
        chanceOfRain = map['chance_of_rain'],
        temp = map['temp_c'].toInt(),
        iconId = int.parse(map['condition']['icon'].substring(
            map['condition']['icon'].length - 7,
            map['condition']['icon'].length - 4)),
        isDay = map['is_day'] == 1;
}
