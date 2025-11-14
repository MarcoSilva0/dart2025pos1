class WeatherData {
  final double latitude;
  final double longitude;
  final double generationtimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;
  final HourlyUnits hourlyUnits;
  final HourlyData hourly;

  const WeatherData({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.hourlyUnits,
    required this.hourly,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'latitude': double latitude,
        'longitude': double longitude,
        'generationtime_ms': double generationtimeMs,
        'utc_offset_seconds': int utcOffsetSeconds,
        'timezone': String timezone,
        'timezone_abbreviation': String timezoneAbbreviation,
        'elevation': double elevation,
        'hourly_units': Map<String, dynamic> hourlyUnits,
        'hourly': Map<String, dynamic> hourly,
      } =>
        WeatherData(
          latitude: latitude,
          longitude: longitude,
          generationtimeMs: generationtimeMs,
          utcOffsetSeconds: utcOffsetSeconds,
          timezone: timezone,
          timezoneAbbreviation: timezoneAbbreviation,
          elevation: elevation,
          hourlyUnits: HourlyUnits.fromJson(hourlyUnits),
          hourly: HourlyData.fromJson(hourly),
        ),
      _ => throw const FormatException('Failed to load weather data.'),
    };
  }
}

class HourlyUnits {
  final String time;
  final String temperature2m;
  final String windSpeed10m;
  final String relativeHumidity2m;

  const HourlyUnits({
    required this.time,
    required this.temperature2m,
    required this.windSpeed10m,
    required this.relativeHumidity2m,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'time': String time,
        'temperature_2m': String temperature2m,
        'wind_speed_10m': String windSpeed10m,
        'relative_humidity_2m': String relativeHumidity2m,
      } =>
        HourlyUnits(
          time: time,
          temperature2m: temperature2m,
          windSpeed10m: windSpeed10m,
          relativeHumidity2m: relativeHumidity2m,
        ),
      _ => throw const FormatException('Failed to load hourly units.'),
    };
  }
}

class HourlyData {
  final List<String> time;
  final List<double> temperature2m;
  final List<double> windSpeed10m;
  final List<int> relativeHumidity2m;

  const HourlyData({
    required this.time,
    required this.temperature2m,
    required this.windSpeed10m,
    required this.relativeHumidity2m,
  });

  factory HourlyData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'time': List<dynamic> time,
        'temperature_2m': List<dynamic> temperature2m,
        'wind_speed_10m': List<dynamic> windSpeed10m,
        'relative_humidity_2m': List<dynamic> relativeHumidity2m,
      } =>
        HourlyData(
          time: time.cast<String>(),
          temperature2m: temperature2m.cast<double>(),
          windSpeed10m: windSpeed10m.cast<double>(),
          relativeHumidity2m: relativeHumidity2m.cast<int>(),
        ),
      _ => throw const FormatException('Failed to load hourly data.'),
    };
  }
}
