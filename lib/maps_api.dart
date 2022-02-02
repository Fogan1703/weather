import 'dart:convert';

import 'package:http/http.dart';
import 'package:weather/weather_data.dart';

const _apiKey = 'AIzaSyADC8nDdhW9pLuBqNkSiya8Ti9Uvmb1oXM';

class MapsAPI {
  static final Client _client = Client();

  static Future<List<String>> getSuggestions({
    required String input,
    required String lang,
    required List<LocationData> exclude,
  }) async {
    if (input.isEmpty) {
      return [];
    }
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$input'
        '&types=(cities)'
        '&language=ru'
        '&key=$_apiKey';
    final response = await _client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return List.of(result['predictions'])
            .map((map) => map['description'] as String)
            .where((suggestion) {
          for (final excluded in exclude) {
            if (suggestion == excluded.fullName && excluded.isCurrent == false) {
              return false;
            }
          }
          return true;
        }).toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
