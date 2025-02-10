import 'package:flutter/material.dart';
import 'package:weather_app/weather_service.dart';

class DailyColumn {
  WeatherService weatherService = WeatherService();
  
  Column dailyColumn(dailyData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          dailyData["weekday"],
          style: TextStyle(color: Colors.white),
        ),
        Flexible(
          child: Image.asset(
            weatherService.getImagePath(dailyData["weather_code"], 1),
            width: 25, // Define a largura máxima
            height: 25, // Define a altura máxima
            fit: BoxFit.contain, // Ajusta a imagem ao espaço disponível
          ),
        ),
        Text(
          "${dailyData["max_temp"].toInt()}º",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          "${dailyData["min_temp"].toInt()}º",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
