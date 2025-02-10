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
                    "$weatherApiUrl?latitude=${cities['lat']}&longitude=${cities['lon']}&timezone=GMT-3&current=temperature_2m,is_day,weather_code&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation_probability,weather_code&daily=temperature_2m_max,temperature_2m_min"))
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

  List<Map<String, dynamic>> filterFutureWeather(Map<String, dynamic> data) {
    // Parse the current time from the API response
    String currentTimeStr = data["current"]["time"];
    DateTime currentTime = DateTime.parse(currentTimeStr);

    // Get the hourly times
    List<String> hourlyTimes = List<String>.from(data["hourly"]["time"]);

    // Filter the times after the current time
    List<String> futureTimes = hourlyTimes.where((timeStr) {
      DateTime time = DateTime.parse(timeStr);
      return time.isAfter(currentTime);
    }).toList();

    // If needed, map future times to their respective data (temperature, weather code, etc.)
    List<Map<String, dynamic>> futureWeatherData = futureTimes.map((timeStr) {
      int index = hourlyTimes.indexOf(timeStr);
      return {
        "time": timeStr,
        "temperature": data["hourly"]["temperature_2m"][index],
        "weather_code": data["hourly"]["weather_code"][index],
        "humidity": data["hourly"]["relative_humidity_2m"][index],
        "precipitation": data["hourly"]["precipitation_probability"][index],
      };
    }).toList();

    return futureWeatherData;
  }

  String getImagePath(int code, int day) {
    String path = "assets/img/";
    path += code >= 0 && code <= 3
        ? day == 1
            ? "day/"
            : "night/"
        : "";
    path += "$code.png";

    return path;
  }
}
