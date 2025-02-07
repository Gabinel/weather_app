import 'package:flutter/material.dart';
import 'package:weather_app/weather_service.dart';

// Cria um stateful widget, ou seja, um widget que pode mudar de estado
class Home extends StatefulWidget {
  const Home({super.key});

  // Cria um estado do widget atual (chama a função abaixo)
  @override
  State<Home> createState() => _HomeState();
}

// Estado do widget atual
class _HomeState extends State<Home> {
  WeatherService weatherService = WeatherService();
  String city = '';
  String state = '';
  String country = '';
  Map<dynamic, dynamic>? weatherData;

  void getWeather() async {
    if (city != '' && state != '' && country != '') {
      var data = await weatherService.fetchWeather(city, state, country);

      setState(() {
        weatherData = data;
        print(
            "DADOSSSSSSSSSSSSSSSSSSSSSS AAAAAAAAAAAAAAAAAAAAAAAAAAAA!!!!!!!!!!!!!!!!!!: $weatherData");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Climate Mobile',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 69, 70, 122),
            centerTitle: true),
        body: Container(
          padding: EdgeInsets.all(20),
          color: const Color.fromARGB(255, 69, 70, 122),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Enter your city name:',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    city = value;
                    getWeather();
                  });
                },
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Enter your state name:',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    state = value;
                    getWeather();
                  });
                },
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Enter your country name:',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    country = value;
                    getWeather();
                  });
                },
              ),
              weatherData == null
                  ? const Text(
                      'Enter your address and press enter',
                      style: TextStyle(color: Colors.white),
                    )
                  : weatherData!.containsKey("hourly") &&
                          weatherData!["hourly"].containsKey("temperature_2m")
                      ? Column(
                          children: List<Widget>.from(
                            weatherData!["hourly"]["temperature_2m"]
                                .map<Widget>((value) {
                              return Text(
                                "$valueºC",
                                style: const TextStyle(color: Colors.white),
                              );
                            }).toList(),
                          ),
                        )
                      : const Text(
                          'No results found',
                          style: TextStyle(color: Colors.white),
                        ),
            ],
          ),
        ));
  }
}
