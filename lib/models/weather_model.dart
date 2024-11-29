class WeatherModel {
  String? name;
  String? region;
  String? country;
  String? lastUpdated;
  double? temp;
  String? text;
  String? icon;
  WeatherModel(
      {this.name,
      this.region,
      this.country,
      this.temp,
      this.text,
      this.lastUpdated,
      this.icon});

  factory WeatherModel.fromjson(Map<String, dynamic> map) {
    return WeatherModel(
      name: map['location']['name'] ?? 'null',
      region: map['location']['region'] ?? 'null',
      country: map['location']['country'] ?? 'null',
      lastUpdated: map['current']['last_updated'] ?? 'null',
      temp: map['current']['temp_c'] ?? 0.0,
      text: map['current']['condition']['text'] ?? 'null',
      icon: map['current']['condition']['icon'],
    );
  }
}
