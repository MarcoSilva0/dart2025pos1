import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'models/weather_data.dart';
import 'services/weather_service.dart';

void main() {
  runApp(const AppMeteorologia());
}

class AppMeteorologia extends StatefulWidget {
  const AppMeteorologia({super.key});

  @override
  State<AppMeteorologia> createState() => _AppMeteorologiaState();
}

class _AppMeteorologiaState extends State<AppMeteorologia> {
  WeatherData? weatherData;
  bool isLoading = false;
  String? errorMessage;
  Map<String, String>? currentLocation;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _loadCurrentLocation();
    await _loadWeatherData();
  }

  Future<void> _loadCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Localização negada pelo usuário.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização permanentemente negada.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLocation = {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      };
    });
  }

  Future<void> _loadWeatherData() async {
    if (currentLocation == null) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await WeatherService.fetchWeatherData(
        latitude: currentLocation!['latitude']!,
        longitude: currentLocation!['longitude']!,
      );

      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Meteorologia IFSP',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Meteorologia IFSP'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadWeatherData,
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
                child: ElevatedButton(
                  onPressed: _loadWeatherData,
                  child: const Text('Tentar novamente'),
                ),
              )
            : weatherData == null
            ? const Center(child: Text('Nenhum dado disponível'))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temperatura: ${weatherData!.hourly.temperature2m.isNotEmpty ? weatherData!.hourly.temperature2m.first : "--"}${weatherData!.hourlyUnits.temperature2m}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Umidade: ${weatherData!.hourly.relativeHumidity2m.isNotEmpty ? weatherData!.hourly.relativeHumidity2m.first : "--"}${weatherData!.hourlyUnits.relativeHumidity2m}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Velocidade do Vento: ${weatherData!.hourly.windSpeed10m.isNotEmpty ? weatherData!.hourly.windSpeed10m.first : "--"} ${weatherData!.hourlyUnits.windSpeed10m}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
