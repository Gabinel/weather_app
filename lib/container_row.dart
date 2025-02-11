import 'package:flutter/material.dart';
import 'package:weather_app/weather_service.dart';

class ContainerRow {
  WeatherService weatherService = WeatherService();

  Row containerRow(Map<String, dynamic> weatherFutureData) {
    String today = weatherFutureData["time"].split('T')[0];
    DateTime currentTime = DateTime.parse(weatherFutureData["time"]);
    DateTime night = DateTime.parse("${today}T19:00");
    DateTime day = DateTime.parse("${today}T06:00");

    int isDay = currentTime.isBefore(night) && currentTime.isAfter(day) ? 1 : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${weatherFutureData["time"].split('T')[1]}",
            style: TextStyle(color: Colors.white)),
        Flexible(
          child: Image.asset(
            weatherService.getImagePath(
                weatherFutureData["weather_code"], isDay),
            width: 50, // Define a largura máxima
            height: 50, // Define a altura máxima
            fit: BoxFit.contain, // Ajusta a imagem ao espaço disponível
          ),
        ),
        Text("${weatherFutureData["temperature"].toInt()}ºC",
            style: TextStyle(color: Colors.white)),
        Flexible(
          child: Image.asset(
            "assets/img/drop.png",
            width: 25, // Define a largura máxima
            height: 25, // Define a altura máxima
            fit: BoxFit.contain, // Ajusta a imagem ao espaço disponível
          ),
        ),
        Text("${weatherFutureData["precipitation"].toInt()}%",
            style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
