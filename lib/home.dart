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
  String imagePath = "assets/img/";
  String displayText = '';

  void getWeather() async {
    if (city != '' && state != '' && country != '') {
      var data = await weatherService.fetchWeather(city, state, country);
      int weatherCode = data["current"]["weather_code"];
      int isDay = data["current"]["is_day"];
      imagePath = "assets/img/";

      setState(() {
        weatherData = data;
        print(
            "DADOSSSSSSSSSSSSSSSSSSSSSS AAAAAAAAAAAAAAAAAAAAAAAAAAAA!!!!!!!!!!!!!!!!!!: $weatherData");

        imagePath = weatherCode >= 51 && weatherCode <= 55
            ? "${imagePath}drizzle.png"
            : weatherCode >= 45 && weatherCode <= 48
                ? "${imagePath}fog.png"
                : weatherCode >= 61 && weatherCode <= 65
                    ? "${imagePath}rain.png"
                    : weatherCode >= 95 && weatherCode <= 99
                        ? "${imagePath}thunder.png"
                        : weatherCode >= 0 && weatherCode <= 1
                            ? isDay == 1
                                ? "${imagePath}day/clear.png"
                                : "${imagePath}night/clear.png"
                            : weatherCode >= 2 && weatherCode <= 3
                                ? isDay == 1
                                    ? "${imagePath}day/partly_cloudy.png"
                                    : "${imagePath}night/partly_cloudy.png"
                                : "${imagePath}day/clear.png";

        List<String> weatherType = imagePath.split('/');

        displayText = isDay == 1 ? "Day - " : "Night - ";
        displayText += "The weather is ";
        displayText += weatherType[weatherType.length - 1];
        displayText = displayText.split('.')[0];
        if (displayText.contains('_')) {
          displayText =
              "${displayText.split('_')[0]} ${displayText.split('_')[1]}";
        }
        displayText += " right now!";
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(255, 69, 70, 122),
                  Color.fromARGB(255, 41, 41, 77)
                ]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'City',
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
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'State',
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
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Country',
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              /*
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
                        */
              weatherData == null
                  ? const Text(
                      'Enter your address and press enter',
                      style: TextStyle(color: Colors.white),
                    )
                  : Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${weatherData!["current"]["temperature_2m"].toInt()}ºC",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontWeight: FontWeight.bold),
                          ),
                          Flexible(
                            child: Image.asset(
                              imagePath,
                              width: 100, // Define a largura máxima
                              height: 100, // Define a altura máxima
                              fit: BoxFit
                                  .contain, // Ajusta a imagem ao espaço disponível
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 70),
              Container(
                width: 375,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Color.fromARGB(255, 31, 31, 59),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        displayText,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
