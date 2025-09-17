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
  final String apiKey = "fa10d3786000ecae94e7185fa6eb9ed4"; // OpenWeather API Key
  final TextEditingController _cityController = TextEditingController();

  String city = "";
  String condition = "";
  double? temperature;
  String iconCode = "";
  String message = "Fetching weather...";

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
        setState(() => message = "Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => message = "Location permission denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => message =
            "Location permissions are permanently denied. Enable them in settings.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() => message = "Error fetching location: $e");
    }
  }

  // 🌍 Get weather by city name
  Future<void> _getWeatherByCity(String cityName) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _updateWeatherData(data);
      } else {
        setState(() => message = "City not found!");
      }
    } catch (e) {
      setState(() => message = "Error fetching weather: $e");
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
        _updateWeatherData(data);
      } else {
        setState(() => message = "Unable to fetch weather data.");
      }
    } catch (e) {
      setState(() => message = "Error fetching weather: $e");
    }
  }

  // 🎯 Update UI with API response
  void _updateWeatherData(dynamic data) {
    setState(() {
      city = data['name'];
      temperature = data['main']['temp'];
      condition = data['weather'][0]['description'];
      iconCode = data['weather'][0]['icon'];
      message = "";
    });
  }

  // 🌈 Gradient based on weather
  LinearGradient _getBackgroundGradient() {
    if (condition.contains("rain")) {
      return const LinearGradient(colors: [Colors.blueGrey, Colors.blue]);
    } else if (condition.contains("cloud")) {
      return const LinearGradient(colors: [Colors.grey, Colors.blueGrey]);
    } else {
      return const LinearGradient(colors: [Colors.orange, Colors.yellow]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: _getBackgroundGradient()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (message.isNotEmpty)
                Text(
                  message,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                )
              else
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          city,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        if (iconCode.isNotEmpty)
                          Image.network(
                            "https://openweathermap.org/img/wn/$iconCode@2x.png",
                            width: 80,
                            height: 80,
                          ),
                        Text(
                          "${temperature?.toStringAsFixed(1)}°C",
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          condition,
                          style: const TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
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
                  final cityName = _cityController.text.trim();
                  if (cityName.isNotEmpty) {
                    _getWeatherByCity(cityName);
                  }
                },
                child: const Text("Get Weather"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _getWeatherByLocation,
                child: const Text("Get Current Location Weather"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _cityController.clear();
                    city = "";
                    condition = "";
                    temperature = null;
                    iconCode = "";
                    message = "Enter a city or use GPS 🌍";
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Clear"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
