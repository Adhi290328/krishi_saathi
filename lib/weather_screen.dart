import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  String weatherInfo = "Fetching weather...";
  final String apiKey =
      "fa10d3786000ecae94e7185fa6eb9ed4"; // Replace with your OpenWeather API Key
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getWeatherByLocation();
  }

  // 📍 Get weather by current location
  Future<void> _getWeatherByLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          weatherInfo = "Location services are disabled.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            weatherInfo = "Location permission denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          weatherInfo =
              "Location permissions are permanently denied. Enable them in settings.";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        weatherInfo = "Error fetching location: $e";
      });
    }
  }

  // 🌍 Get weather by city name
  Future<void> _getWeatherByCity(String city) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          weatherInfo =
              "City: ${data['name']}, Temp: ${data['main']['temp']}°C, Condition: ${data['weather'][0]['description']}";
        });
      } else {
        setState(() {
          weatherInfo = "City not found!";
        });
      }
    } catch (e) {
      setState(() {
        weatherInfo = "Error fetching weather: $e";
      });
    }
  }

  // 🔎 Fetch weather by latitude & longitude
  Future<void> _fetchWeather(double lat, double lon) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          weatherInfo =
              "Location: ${data['name']}, Temp: ${data['main']['temp']}°C, Condition: ${data['weather'][0]['description']}";
        });
      } else {
        setState(() {
          weatherInfo = "Unable to fetch weather data.";
        });
      }
    } catch (e) {
      setState(() {
        weatherInfo = "Error fetching weather: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weatherInfo,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter city name",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final city = _cityController.text.trim();
                if (city.isNotEmpty) {
                  _getWeatherByCity(city);
                }
              },
              child: const Text("Get Weather"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeatherByLocation,
              child: const Text("Get Current Location Weather"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cityController.clear();
                  weatherInfo = "Enter a city or use GPS 🌍";
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Clear"),
            ),
          ],
        ),
      ),
    );
  }
}
