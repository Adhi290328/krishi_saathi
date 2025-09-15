import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  String _weatherInfo = "";

  void _getWeather() {
    // For now, just dummy weather info
    setState(() {
      _weatherInfo = "🌤️ Weather in ${_controller.text}:\n"
          "Temperature: 28°C\n"
          "Humidity: 70%\n"
          "Rain chance: 40%";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter your city/village",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _getWeather,
              child: const Text("Check Weather"),
            ),
            const SizedBox(height: 20),
            if (_weatherInfo.isNotEmpty)
              Text(
                _weatherInfo,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
}
