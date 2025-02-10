import 'package:flutter/material.dart';
import 'package:weather_app/weather_service.dart';

class ContainerRow {
  WeatherService weatherService = WeatherService();

  Row containerRow(Map<String, dynamic> weatherFutureData, int isDay) {
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
