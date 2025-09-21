import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  static String get _apiKey {
    try {
      if (dotenv.isInitialized) {
        return dotenv.env['OPENWEATHER_API_KEY'] ?? '';
      }
    } catch (e) {
      print('Error accessing OpenWeather API key: $e');
    }
    return '';
  }

  static Future<WeatherData?> getCurrentWeather(String city) async {
    if (_apiKey.isEmpty) {
      print('OpenWeather API key not found');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        print('Weather API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather: $e');
      return null;
    }
  }

  static Future<List<ForecastData>> getForecast(String city, {int days = 5}) async {
    if (_apiKey.isEmpty) {
      print('OpenWeather API key not found');
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric&cnt=${days * 8}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];
        
        return forecastList
            .map((item) => ForecastData.fromJson(item))
            .toList();
      } else {
        print('Forecast API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching forecast: $e');
      return [];
    }
  }

  static Future<WeatherData?> getWeatherByCoords(double lat, double lon) async {
    if (_apiKey.isEmpty) {
      print('OpenWeather API key not found');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        print('Weather API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather by coordinates: $e');
      return null;
    }
  }
}

class WeatherData {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final int pressure;
  final double visibility;
  final DateTime dateTime;

  WeatherData({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.pressure,
    required this.visibility,
    required this.dateTime,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      pressure: json['main']['pressure'] ?? 0,
      visibility: (json['visibility'] ?? 0).toDouble() / 1000, // Convert to km
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/w/$icon.png';
  
  String get temperatureString => '${temperature.round()}°C';
  
  String get feelsLikeString => 'Feels like ${feelsLike.round()}°C';
  
  bool get isGoodForFarming {
    // Simple logic for farming conditions
    return temperature >= 15 && 
           temperature <= 35 && 
           humidity >= 40 && 
           humidity <= 70 && 
           windSpeed < 10;
  }
  
  String get farmingAdvice {
    if (temperature < 15) return 'Too cold for most crops';
    if (temperature > 35) return 'Too hot - ensure adequate irrigation';
    if (humidity < 40) return 'Low humidity - increase watering';
    if (humidity > 70) return 'High humidity - watch for fungal diseases';
    if (windSpeed > 10) return 'High winds - protect delicate plants';
    return 'Good conditions for farming';
  }
}

class ForecastData {
  final DateTime dateTime;
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final int humidity;
  final String description;
  final String icon;
  final double windSpeed;

  ForecastData({
    required this.dateTime,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.description,
    required this.icon,
    required this.windSpeed,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      minTemp: (json['main']['temp_min'] ?? 0).toDouble(),
      maxTemp: (json['main']['temp_max'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/w/$icon.png';
  
  String get temperatureRange => '${minTemp.round()}° - ${maxTemp.round()}°C';
}