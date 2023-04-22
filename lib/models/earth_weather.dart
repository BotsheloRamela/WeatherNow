class EarthWeather {
  final String cityName;
  final String description;
  final double temperature;
  final int humidity;
  final double windSpeed;

  EarthWeather(
      {required this.cityName,
      required this.description,
      required this.temperature,
      required this.humidity,
      required this.windSpeed});

  factory EarthWeather.fromJson(Map<String, dynamic> json) {
    return EarthWeather(
        cityName: json['name'],
        description: json['weather'][0]['description'],
        temperature: json['main']['temp'].toDouble(),
        humidity: json['main']['humidity'],
        windSpeed: json['wind']['speed'].toDouble()
        );
  }
}
