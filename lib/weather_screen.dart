import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnhancedWeatherScreen extends StatefulWidget {
  const EnhancedWeatherScreen({super.key});

  @override
  State<EnhancedWeatherScreen> createState() => _EnhancedWeatherScreenState();
}

class _EnhancedWeatherScreenState extends State<EnhancedWeatherScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Safe API key access with proper error handling
  String get apiKey {
    try {
      if (dotenv.isInitialized) {
        return dotenv.env['OPENWEATHER_API_KEY'] ?? '';
      }
    } catch (e) {
      debugPrint('Error accessing OpenWeather API key: $e');
    }
    return '';
  }
  
  final TextEditingController _cityController = TextEditingController();

  // Current weather data
  String city = "";
  String condition = "";
  double? temperature;
  double? feelsLike;
  int? humidity;
  double? windSpeed;
  int? pressure;
  double? uvIndex;
  String iconCode = "";
  String message = "Fetching weather...";
  bool _isLoading = true;
  
  // Extended weather data
  List<WeatherForecast> forecasts = [];
  FarmingWeatherInsights? farmingInsights;
  List<WeatherAlert> alerts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Check if API key is available
    if (apiKey.isEmpty) {
      setState(() {
        message = "OpenWeather API key not found. Please check your .env file and ensure OPENWEATHER_API_KEY is set.";
        _isLoading = false;
      });
    } else {
      _getWeatherByLocation();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // Get weather by current location
  Future<void> _getWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      message = "Getting your location...";
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          message = "Location services are disabled. Please enable location services in your device settings.";
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            message = "Location permission denied. Please allow location access to get weather for your area.";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          message = "Location permissions are permanently denied. Please enable location permissions in your device settings to get weather for your area.";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        message = "Getting your current location...";
      });

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      await _fetchWeatherAndForecast(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        message = "Error getting location: ${e.toString()}. Try searching for a city instead.";
        _isLoading = false;
      });
    }
  }

  // Get weather by city name
  Future<void> _getWeatherByCity(String cityName) async {
    if (cityName.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
      message = "Fetching weather for $cityName...";
    });

    try {
      // First get coordinates for the city
      final geoUrl = "https://api.openweathermap.org/geo/1.0/direct?q=${Uri.encodeComponent(cityName)}&limit=1&appid=$apiKey";
      final geoResponse = await http.get(Uri.parse(geoUrl)).timeout(const Duration(seconds: 10));
      
      if (geoResponse.statusCode == 200) {
        final geoData = jsonDecode(geoResponse.body);
        if (geoData.isNotEmpty) {
          final lat = geoData[0]['lat'];
          final lon = geoData[0]['lon'];
          await _fetchWeatherAndForecast(lat, lon);
        } else {
          setState(() {
            message = "City '$cityName' not found. Please check the spelling and try again.";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          message = "Error searching for city. Please try again.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = "Network error: ${e.toString()}. Please check your internet connection.";
        _isLoading = false;
      });
    }
  }

  // Fetch both current weather and 5-day forecast
  Future<void> _fetchWeatherAndForecast(double lat, double lon) async {
    try {
      setState(() {
        message = "Loading weather data...";
      });

      // Fetch current weather and forecast in parallel
      final currentUrl = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
      final forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
      
      final responses = await Future.wait([
        http.get(Uri.parse(currentUrl)).timeout(const Duration(seconds: 10)),
        http.get(Uri.parse(forecastUrl)).timeout(const Duration(seconds: 10)),
      ]);

      final currentResponse = responses[0];
      final forecastResponse = responses[1];

      if (currentResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        final currentData = jsonDecode(currentResponse.body);
        final forecastData = jsonDecode(forecastResponse.body);
        
        _updateWeatherData(currentData, forecastData);
        _generateFarmingInsights();
        _generateWeatherAlerts();
        
        setState(() {
          message = "";
          _isLoading = false;
        });
      } else {
        setState(() {
          message = "Unable to fetch weather data. API Error: ${currentResponse.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = "Error fetching weather data: ${e.toString()}. Please check your internet connection.";
        _isLoading = false;
      });
    }
  }

  // Update UI with API response
  void _updateWeatherData(dynamic currentData, dynamic forecastData) {
    try {
      // Current weather
      city = currentData['name'] ?? 'Unknown Location';
      temperature = (currentData['main']['temp'] as num?)?.toDouble();
      feelsLike = (currentData['main']['feels_like'] as num?)?.toDouble();
      humidity = currentData['main']['humidity'] as int?;
      windSpeed = ((currentData['wind']?['speed'] as num?) ?? 0) * 3.6; // Convert m/s to km/h
      pressure = currentData['main']['pressure'] as int?;
      condition = currentData['weather']?[0]?['description'] ?? 'Unknown';
      iconCode = currentData['weather']?[0]?['icon'] ?? '';
      uvIndex = 0.0; // OpenWeather free tier doesn't include UV index
      
      // Forecast data (group by day)
      forecasts.clear();
      Map<String, List<dynamic>> dailyForecasts = {};
      
      final forecastList = forecastData['list'] as List<dynamic>? ?? [];
      
      for (var item in forecastList) {
        try {
          final dateStr = item['dt_txt'] as String?;
          if (dateStr != null) {
            final date = DateTime.parse(dateStr).toLocal();
            final dateKey = _formatDateKey(date);
            
            if (!dailyForecasts.containsKey(dateKey)) {
              dailyForecasts[dateKey] = [];
            }
            dailyForecasts[dateKey]!.add(item);
          }
        } catch (e) {
          // Skip invalid forecast items
          continue;
        }
      }
      
      // Create daily forecast summaries
      dailyForecasts.forEach((dateStr, dayData) {
        if (forecasts.length < 5) { // Limit to 5 days
          try {
            final date = DateTime.parse(dateStr);
            final temps = dayData
                .map((d) => (d['main']?['temp'] as num?)?.toDouble() ?? 0.0)
                .where((temp) => temp > -100) // Filter out invalid temps
                .toList();
                
            final conditions = dayData
                .map((d) => d['weather']?[0]?['description'] as String? ?? 'Unknown')
                .where((c) => c.isNotEmpty)
                .toList();
                
            final rainfall = dayData
                .map((d) => ((d['rain']?['3h'] as num?) ?? 0.0).toDouble())
                .toList();

            if (temps.isNotEmpty) {
              forecasts.add(WeatherForecast(
                date: date,
                maxTemp: temps.reduce((a, b) => a > b ? a : b),
                minTemp: temps.reduce((a, b) => a < b ? a : b),
                description: conditions.isNotEmpty ? conditions.first : 'Unknown',
                iconCode: dayData.isNotEmpty ? (dayData.first['weather']?[0]?['icon'] ?? '') : '',
                chanceOfRain: rainfall.isNotEmpty ? (rainfall.reduce((a, b) => a + b) > 0 ? 70.0 : 20.0) : 0.0,
                rainfall: rainfall.isNotEmpty ? rainfall.reduce((a, b) => a + b) : 0.0,
                avgHumidity: dayData.isNotEmpty 
                    ? (dayData.map((d) => (d['main']?['humidity'] as int?) ?? 0).reduce((a, b) => a + b) / dayData.length)
                    : 0.0,
                maxWind: dayData.isNotEmpty
                    ? dayData.map((d) => ((d['wind']?['speed'] as num?) ?? 0) * 3.6).reduce((a, b) => a > b ? a : b).toDouble()
                    : 0.0,
              ));
            }
          } catch (e) {
            // Skip invalid forecast data
            debugPrint('Error parsing forecast item: $e');
          }
        }
      });
      
    } catch (e) {
      // Handle parsing errors gracefully
      debugPrint('Error parsing weather data: $e');
    }
  }

  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}";
  }

  void _generateFarmingInsights() {
    if (temperature == null || humidity == null) return;
    
    List<String> recommendations = [];
    Map<String, bool> activities = {};
    
    final temp = temperature!;
    final hum = humidity!;
    final wind = windSpeed ?? 0;
    final rain = forecasts.isNotEmpty ? forecasts[0].rainfall : 0.0;
    
    // Generate recommendations based on weather
    if (temp > 30) {
      recommendations.add('High temperature detected - increase irrigation frequency');
      recommendations.add('Apply mulch to reduce soil temperature');
      recommendations.add('Avoid midday field work');
    } else if (temp < 15) {
      recommendations.add('Cool weather - protect sensitive crops from cold');
      recommendations.add('Consider frost protection measures');
    } else {
      recommendations.add('Temperature is optimal for most farming activities');
    }
    
    if (hum > 80) {
      recommendations.add('High humidity - monitor for fungal diseases');
      recommendations.add('Improve air circulation around plants');
    } else if (hum < 40) {
      recommendations.add('Low humidity - increase irrigation');
    } else {
      recommendations.add('Humidity levels are good for crop health');
    }
    
    if (rain > 20) {
      recommendations.add('Heavy rainfall expected - check drainage systems');
      recommendations.add('Avoid heavy machinery use on wet fields');
    } else if (rain < 2 && temp > 25) {
      recommendations.add('Dry conditions - ensure adequate irrigation');
    }
    
    if (wind > 30) {
      recommendations.add('Strong winds - secure tall plants and structures');
      recommendations.add('Avoid pesticide application due to drift risk');
    }
    
    // Activity suitability
    activities['planting'] = temp >= 15 && temp <= 30 && rain < 15 && wind < 25;
    activities['irrigation'] = rain < 5 && temp > 20;
    activities['harvesting'] = rain < 5 && hum < 70 && wind < 30;
    activities['spraying'] = wind < 15 && rain < 2 && hum > 50;
    activities['fieldWork'] = rain < 10 && wind < 25;
    activities['fertilizing'] = rain < 10 && wind < 20;
    
    // Soil moisture estimation
    int soilMoisture = ((hum + (rain * 10)) / 2).clamp(0, 100).round();
    
    // Best time for work
    String bestTime;
    if (temp > 35) {
      bestTime = 'Early morning (5-8 AM) or late evening (5-7 PM)';
    } else if (temp > 25) {
      bestTime = 'Morning hours (6-10 AM) preferred';
    } else {
      bestTime = 'All day suitable for most activities';
    }
    
    String overallCondition;
    int suitableActivities = activities.values.where((suitable) => suitable).length;
    if (suitableActivities >= 4) {
      overallCondition = 'Excellent conditions for farming activities';
    } else if (suitableActivities >= 2) {
      overallCondition = 'Good conditions for most farming activities';
    } else {
      overallCondition = 'Limited farming activities recommended';
    }
    
    farmingInsights = FarmingWeatherInsights(
      overallCondition: overallCondition,
      recommendations: recommendations,
      activitySuitability: activities,
      soilMoistureIndex: soilMoisture,
      bestTimeForWork: bestTime,
    );
  }

  void _generateWeatherAlerts() {
    alerts.clear();
    
    if (temperature == null) return;
    
    if (temperature! > 35) {
      alerts.add(WeatherAlert(
        type: AlertType.highTemperature,
        message: 'High temperature warning! Ensure adequate irrigation and avoid midday work.',
        severity: AlertSeverity.warning,
      ));
    }
    
    if (temperature! < 5) {
      alerts.add(WeatherAlert(
        type: AlertType.frost,
        message: 'Frost warning! Protect sensitive crops and seedlings.',
        severity: AlertSeverity.severe,
      ));
    }
    
    if (forecasts.isNotEmpty && forecasts[0].rainfall > 25) {
      alerts.add(WeatherAlert(
        type: AlertType.heavyRain,
        message: 'Heavy rainfall expected. Avoid field operations and check drainage.',
        severity: AlertSeverity.severe,
      ));
    }
    
    if ((windSpeed ?? 0) > 50) {
      alerts.add(WeatherAlert(
        type: AlertType.strongWind,
        message: 'Strong wind warning! Secure equipment and tall plants.',
        severity: AlertSeverity.warning,
      ));
    }
    
    if ((humidity ?? 0) > 85) {
      alerts.add(WeatherAlert(
        type: AlertType.highHumidity,
        message: 'High humidity may increase disease risk. Monitor crops closely.',
        severity: AlertSeverity.info,
      ));
    }
  }

  LinearGradient _getBackgroundGradient() {
    if (condition.contains("rain") || condition.contains("drizzle")) {
      return const LinearGradient(
        colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (condition.contains("cloud")) {
      return const LinearGradient(
        colors: [Color(0xFF8E9AAF), Color(0xFF6B7B8C)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (condition.contains("thunder")) {
      return const LinearGradient(
        colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  IconData _getWeatherIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('sun') || desc.contains('clear')) {
      return Icons.wb_sunny;
    } else if (desc.contains('cloud')) {
      return Icons.cloud;
    } else if (desc.contains('rain') || desc.contains('drizzle')) {
      return Icons.water_drop;
    } else if (desc.contains('thunder') || desc.contains('storm')) {
      return Icons.thunderstorm;
    } else if (desc.contains('snow')) {
      return Icons.ac_unit;
    } else if (desc.contains('mist') || desc.contains('fog')) {
      return Icons.foggy;
    } else {
      return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Current', icon: Icon(Icons.wb_sunny)),
            Tab(text: 'Forecast', icon: Icon(Icons.calendar_today)),
            Tab(text: 'Farming', icon: Icon(Icons.agriculture)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _getWeatherByLocation,
            tooltip: 'Refresh weather',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: _getBackgroundGradient()),
        child: _isLoading ? _buildLoadingState() : _buildContent(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (message.isNotEmpty) {
      return _buildErrorState();
    }
    
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCurrentWeatherTab(),
              _buildForecastTab(),
              _buildFarmingTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              message.contains('Location') ? Icons.location_off : Icons.cloud_off,
              size: 80, 
              color: Colors.white
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _getWeatherByLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityController,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: "Search city...",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _getWeatherByCity(value.trim());
                      _cityController.clear();
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.my_location, color: Colors.green.shade700),
                onPressed: _getWeatherByLocation,
                tooltip: 'Use current location',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMainWeatherCard(),
          const SizedBox(height: 16),
          if (alerts.isNotEmpty) ...[
            _buildWeatherAlertsCard(),
            const SizedBox(height: 16),
          ],
          _buildWeatherDetailsGrid(),
        ],
      ),
    );
  }

  Widget _buildMainWeatherCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    city,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${temperature?.toStringAsFixed(1) ?? '--'}°C",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    if (feelsLike != null)
                      Text(
                        "Feels like ${feelsLike!.toStringAsFixed(1)}°C",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      condition.toUpperCase(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  children: [
                    if (iconCode.isNotEmpty)
                      Image.network(
                        "https://openweathermap.org/img/wn/$iconCode@4x.png",
                        width: 100,
                        height: 100,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => 
                          Icon(_getWeatherIcon(condition), size: 80, color: Colors.blue.shade600),
                      )
                    else
                      Icon(_getWeatherIcon(condition), size: 80, color: Colors.blue.shade600),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildDetailCard('Humidity', '${humidity ?? 0}%', Icons.water_drop, Colors.blue),
        _buildDetailCard('Wind Speed', '${windSpeed?.toStringAsFixed(1) ?? 0} km/h', Icons.air, Colors.teal),
        _buildDetailCard('Pressure', '${pressure ?? 0} hPa', Icons.speed, Colors.purple),
        _buildDetailCard('Condition', condition.isNotEmpty ? condition : 'Unknown', _getWeatherIcon(condition), Colors.orange),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherAlertsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                const Text('Weather Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ...alerts.map((alert) => _buildAlertItem(alert)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(WeatherAlert alert) {
    Color alertColor;
    IconData alertIcon;
    
    switch (alert.severity) {
      case AlertSeverity.severe:
        alertColor = Colors.red;
        alertIcon = Icons.error;
        break;
      case AlertSeverity.warning:
        alertColor = Colors.orange;
        alertIcon = Icons.warning;
        break;
      case AlertSeverity.info:
        alertColor = Colors.blue;
        alertIcon = Icons.info;
        break;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alertColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: alertColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(alertIcon, color: alertColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              alert.message,
              style: TextStyle(color: alertColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '5-Day Forecast',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          if (forecasts.isEmpty)
            const Center(
              child: Text(
                'No forecast data available',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          else
            ...forecasts.map((forecast) => _buildForecastCard(forecast)),
        ],
      ),
    );
  }

  Widget _buildForecastCard(WeatherForecast forecast) {
    final isToday = forecast.date.day == DateTime.now().day && 
                   forecast.date.month == DateTime.now().month;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isToday 
            ? LinearGradient(colors: [Colors.blue.shade50, Colors.white])
            : const LinearGradient(colors: [Colors.white, Colors.white]),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isToday ? 'Today' : _getDayName(forecast.date.weekday),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.blue.shade700 : Colors.black,
                    ),
                  ),
                  Text(
                    _formatDate(forecast.date),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    forecast.description,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  if (forecast.iconCode.isNotEmpty)
                    Image.network(
                      "https://openweathermap.org/img/wn/${forecast.iconCode}@2x.png",
                      width: 50,
                      height: 50,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => 
                        Icon(_getWeatherIcon(forecast.description), size: 40, color: Colors.blue),
                    )
                  else
                    Icon(_getWeatherIcon(forecast.description), size: 40, color: Colors.blue),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${forecast.maxTemp.round()}°',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${forecast.minTemp.round()}°',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  if (forecast.chanceOfRain > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water_drop, size: 14, color: Colors.blue.shade600),
                        Text(
                          ' ${forecast.chanceOfRain.round()}%',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (farmingInsights != null) 
            _buildFarmingInsightsCard()
          else
            const Center(
              child: Text(
                'No farming insights available',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          const SizedBox(height: 16),
          if (farmingInsights != null) _buildActivitySuitabilityCard(),
        ],
      ),
    );
  }

  Widget _buildFarmingInsightsCard() {
    final insights = farmingInsights!;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.agriculture, color: Colors.green.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Farming Insights',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Text(
                insights.overallCondition,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (insights.recommendations.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Recommendations:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...insights.recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rec,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
            ],
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: Colors.blue.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Best time for work: ${insights.bestTimeForWork}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySuitabilityCard() {
    final insights = farmingInsights!;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: Colors.green.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Activity Suitability',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...insights.activitySuitability.entries.map((entry) {
              return _buildActivitySuitabilityItem(entry.key, entry.value);
            }),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.water, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Soil Moisture Index: ${insights.soilMoistureIndex}%',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Container(
                    width: 80,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.shade300,
                    ),
                    child: FractionallySizedBox(
                      widthFactor: (insights.soilMoistureIndex / 100).clamp(0.0, 1.0),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _getSoilMoistureColor(insights.soilMoistureIndex),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySuitabilityItem(String activity, bool suitable) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: suitable ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: suitable ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            suitable ? Icons.check_circle : Icons.cancel,
            color: suitable ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getActivityDisplayName(activity),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: suitable ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: suitable ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              suitable ? 'Suitable' : 'Not Recommended',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getActivityDisplayName(String activity) {
    switch (activity.toLowerCase()) {
      case 'planting':
        return 'Planting & Sowing';
      case 'irrigation':
        return 'Irrigation';
      case 'harvesting':
        return 'Harvesting';
      case 'spraying':
        return 'Spraying & Pesticide Application';
      case 'fieldwork':
        return 'General Field Work';
      case 'fertilizing':
        return 'Fertilizer Application';
      default:
        return activity.split('').map((c) => c == c.toLowerCase() ? c.toUpperCase() : c).join();
    }
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(weekday - 1) % 7];
  }

  Color _getSoilMoistureColor(int moisture) {
    if (moisture < 30) return Colors.red;
    if (moisture < 60) return Colors.orange;
    return Colors.green;
  }
}

// Supporting classes
class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String iconCode;
  final double chanceOfRain;
  final double rainfall;
  final double avgHumidity;
  final double maxWind;

  WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.iconCode,
    required this.chanceOfRain,
    required this.rainfall,
    required this.avgHumidity,
    required this.maxWind,
  });
}

class FarmingWeatherInsights {
  final String overallCondition;
  final List<String> recommendations;
  final Map<String, bool> activitySuitability;
  final int soilMoistureIndex;
  final String bestTimeForWork;

  FarmingWeatherInsights({
    required this.overallCondition,
    required this.recommendations,
    required this.activitySuitability,
    required this.soilMoistureIndex,
    required this.bestTimeForWork,
  });
}

class WeatherAlert {
  final AlertType type;
  final String message;
  final AlertSeverity severity;

  WeatherAlert({
    required this.type,
    required this.message,
    required this.severity,
  });
}

enum AlertType {
  highTemperature,
  heavyRain,
  frost,
  strongWind,
  highHumidity,
}

enum AlertSeverity {
  info,
  warning,
  severe,
}