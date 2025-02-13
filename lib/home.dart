import 'package:flutter/material.dart';
import 'package:weather_app/weather_service.dart';
import 'package:weather_app/container_row.dart';
import 'package:weather_app/daily_column.dart';

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
  DailyColumn dailyColumn = DailyColumn();

  String postalCode = '';
  Map<String, dynamic>? weatherData;
  List<Map<String, dynamic>>? weatherFutureData;
  List<Map<String, dynamic>>? dailyData;
  String imagePath = '';
  String displayText = '';
  String locationName = '';
  int isDay = 0;
  bool celsius = true;

  void getWeather() async {
    if (postalCode != '') {
      var location = await weatherService.fetchLocation(postalCode);
      var data = await weatherService.fetchWeather(location, celsius);
      var futureData = weatherService.filterFutureWeather(data);
      var daily = weatherService.getDailyData(data);
      int weatherCode = data["current"]["weather_code"];

      setState(() {
        weatherData = data;
        weatherFutureData = futureData;
        dailyData = daily;

        List<String> locations = location[0]["display_name"].split(',');

        locationName = '';
        locationName += locations[0];
        locationName += locations.length >= 5 ? ",${locations[4]}" : "";

        isDay = data["current"]["is_day"];

        imagePath = weatherService.getImagePath(weatherCode, isDay);

        displayText = isDay == 1 ? "Day - " : "Night - ";
        displayText += "The weather is ";
        displayText += weatherCode == 0
            ? "clear"
            : weatherCode == 1
                ? "mainly clear"
                : weatherCode >= 2 && weatherCode <= 3
                    ? "partly cloudy"
                    : weatherCode >= 45 && weatherCode <= 48
                        ? "cloudy"
                        : weatherCode >= 51 && weatherCode <= 55
                            ? "drizzling"
                            : weatherCode >= 61 && weatherCode <= 65 ||
                                    weatherCode >= 80 && weatherCode <= 82
                                ? "rainy"
                                : weatherCode >= 71 && weatherCode <= 75
                                    ? "snowy"
                                    : weatherCode == 95
                                        ? "stormy"
                                        : "clear";
        displayText += " right now!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    bool isPortrait = orientation == Orientation.portrait;

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
          child: isPortrait ? portraitLayout() : landscapeLayout(),
        ));
  }

  Widget portraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        locationInputs(),
        const SizedBox(height: 40),
        weatherData == null
            ? const Center(
                child: Text(
                  'Enter your address and press enter',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Expanded(
                child: Column(children: [
                temperatureDisplay(),
                Expanded(
                  child: weatherContent(),
                )
              ])),
      ],
    );
  }

  Widget landscapeLayout() {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                locationInputs(),
                const SizedBox(height: 20),
                weatherData == null
                    ? const Center(
                        child: Text(
                          'Enter your address and press enter',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : temperatureDisplay(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(child: weatherData == null ? Container() : weatherContent()),
      ],
    );
  }

  Widget temperatureDisplay() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      celsius = !celsius;
                      getWeather();
                    });
                  },
                  child: Text(
                    celsius
                        ? "${weatherData!["current"]["temperature_2m"].toInt()}ºC"
                        : "${weatherData!["current"]["temperature_2m"].toInt()}ºF",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      celsius
                          ? "${weatherData!["daily"]["temperature_2m_max"][0].toInt()}ºC"
                          : "${weatherData!["daily"]["temperature_2m_max"][0].toInt()}ºF",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      celsius
                          ? "${weatherData!["daily"]["temperature_2m_min"][0].toInt()}ºC"
                          : "${weatherData!["daily"]["temperature_2m_min"][0].toInt()}ºF",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            Flexible(
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 300,
          height: 35,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(locationName, style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget weatherContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// **First Container**
          SizedBox(
            height: 140,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Color.fromARGB(255, 31, 31, 59),
              ),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dailyColumn.dailyColumn(dailyData![1]),
                    dailyColumn.dailyColumn(dailyData![2]),
                    dailyColumn.dailyColumn(dailyData![3]),
                    dailyColumn.dailyColumn(dailyData![4]),
                    dailyColumn.dailyColumn(dailyData![5]),
                    dailyColumn.dailyColumn(dailyData![6]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          /// **Second Container**
          SizedBox(
            height: 500,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Color.fromARGB(255, 31, 31, 59),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(displayText, style: TextStyle(color: Colors.white)),
                    SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: weatherFutureData!.sublist(0, 7).map((data) {
                        return SizedBox(
                          child: containerRow.containerRow(data, celsius),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget locationInputs() {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Postal Code',
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
                  postalCode = value;
                  getWeather();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
