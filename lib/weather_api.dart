import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather/weather_data.dart';

const _weatherApiKey = '96fc5a87a00147dc871135205221601';
const _geocodingApiKey = 'AIzaSyADC8nDdhW9pLuBqNkSiya8Ti9Uvmb1oXM';

class WeatherAPI {
  WeatherAPI._();

  static Future<LocationData> getCurrentLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    final response = await http.get(Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json'
      '?key=$_weatherApiKey'
      '&q=$latitude,$longitude'
      '&days=3'
      '&lang=${Intl.getCurrentLocale().split('_').first}',
    ));

    String fullName = '';
    final geocodingResponse = await http
        .get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json'
            '?latlng=$latitude,$longitude'
            '&result_type=locality'
            '&language=${Intl.getCurrentLocale().split('_').first}'
            '&amp;'
            '&key=$_geocodingApiKey'));
    final addressComponents =
        jsonDecode(utf8.decode(geocodingResponse.bodyBytes))['results'][0]
            ['address_components'];
    for (final component in addressComponents) {
      if (component['types'].contains('locality') ||
          component['types'].contains('administrative_area_level_1') ||
          component['types'].contains('country')) {
        fullName += component['long_name'] + ', ';
      }
    }
    fullName = fullName.substring(0, fullName.length - 2);

    return LocationData(
      map: jsonDecode(utf8.decode(response.bodyBytes)),
      isCurrent: true,
      fullName: fullName,
    );
  }

  static Future<LocationData> getLocationFromFullName(
    String fullName,
  ) async {
    final response = await http.get(Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json'
      '?key=$_weatherApiKey'
      '&q=$fullName'
      '&days=3'
      '&lang=${Intl.getCurrentLocale().split('_').first}',
    ));

    return LocationData(
      map: jsonDecode(utf8.decode(response.bodyBytes)),
      isCurrent: false,
      fullName: fullName,
    );
  }
}
