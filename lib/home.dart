import 'package:flutter/material.dart';
import 'package:weather_app/weather_service.dart';
import 'package:weather_app/container_row.dart';

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
  ContainerRow containerRow = ContainerRow();
  String city = '';
  String state = '';
  String country = '';
  Map<String, dynamic>? weatherData;
  List<Map<String, dynamic>>? weatherFutureData;
  String imagePath = '';
  String displayText = '';
  int isDay = 0;

  void getWeather() async {
    if (city != '' && state != '' && country != '') {
      var data = await weatherService.fetchWeather(city, state, country);
      var futureData = weatherService.filterFutureWeather(data);
      int weatherCode = data["current"]["weather_code"];

      setState(() {
        weatherData = data;
        weatherFutureData = futureData;

        isDay = data["current"]["is_day"];

        imagePath = weatherService.getImagePath(weatherCode, isDay);

        displayText = isDay == 1 ? "Day - " : "Night - ";
        displayText += "The weather is ";
        displayText += weatherCode == 0
            ? "clear"
            : weatherCode >= 1 && weatherCode <= 3
                ? "partly cloudy"
                : weatherCode >= 45 && weatherCode <= 48
                    ? "cloudy"
                    : weatherCode >= 51 && weatherCode <= 55
                        ? "drizzling"
                        : weatherCode >= 61 && weatherCode <= 65
                            ? "rainy"
                            : weatherCode == 95
                                ? "stormy"
                                : "clear";
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
              weatherData == null
                  ? const Text(
                      'Enter your address and press enter',
                      style: TextStyle(color: Colors.white),
                    )
                  : Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${weatherData!["current"]["temperature_2m"].toInt()}ºC",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Column(children: [
                                  Text(
                                    "${weatherData!["daily"]["temperature_2m_max"][0].toInt()}ºC",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  Text(
                                    "${weatherData!["daily"]["temperature_2m_min"][0].toInt()}ºC",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ])
                              ],
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
                        const SizedBox(height: 70),
                        Container(
                          width: 400,
                          height: 315,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Color.fromARGB(255, 31, 31, 59),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        displayText,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      containerRow.containerRow(
                                          weatherFutureData![0], isDay),
                                      containerRow.containerRow(
                                          weatherFutureData![1], isDay),
                                      containerRow.containerRow(
                                          weatherFutureData![2], isDay),
                                      containerRow.containerRow(
                                          weatherFutureData![3], isDay),
                                      containerRow.containerRow(
                                          weatherFutureData![4], isDay),
                                    ]),
                              ),
                            ],
                          ),
                        )
                      ]),
                    )
            ],
          ),
        ));
  }
}
