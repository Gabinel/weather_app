import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String geocodeApiKey = "67a4c88fa36a2815748822jvl33a587";
  final String geocodeApiUrl = "https://geocode.maps.co/search";
  final String weatherApiUrl = "https://api.open-meteo.com/v1/forecast";

  Future<Map<String, dynamic>> fetchWeather(
      String city, String state, String country) async {
    try {
      final cityResponse = await http
          .get(Uri.parse(
              "$geocodeApiUrl?q=$city,$state,$country&api_key=$geocodeApiKey"))
          .timeout(const Duration(seconds: 10));

      if (cityResponse.statusCode == 200) {
        final decoded = json.decode(cityResponse.body);
        if (decoded is List && decoded.isNotEmpty) {
          final cities = decoded[0];
          if (cities.containsKey('lat') && cities.containsKey('lon')) {
            final response = await http
                .get(Uri.parse(
                    "$weatherApiUrl?latitude=${cities['lat']}&longitude=${cities['lon']}&timezone=GMT-3&current=temperature_2m,is_day,weather_code&hourly=temperature_2m,apparent_temperature,weather_code"))
                .timeout(const Duration(seconds: 10));

            if (response.statusCode == 200) {
              return json.decode(response.body);
            } else {
              throw Exception("Failed to load weather data");
            }
          } else {
            throw Exception("Geolocation data missing lat/lon");
          }
        } else {
          throw Exception("Geocoding API returned no results");
        }
      } else {
        throw Exception("Failed to load geolocation data");
      }
    } catch (e) {
      print("Error in fetchWeather: $e");
      return {};
    }
  }
}
