// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WeatherModel {
  final String placeName;
  final String weather;

  WeatherModel({
    required this.placeName,
    required this.weather,
  });

  WeatherModel copyWith({
    String? placeName,
    String? weather,
  }) {
    return WeatherModel(
      placeName: placeName ?? this.placeName,
      weather: weather ?? this.weather,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placeName': placeName,
      'weather': weather,
    };
  }

  factory WeatherModel.fromNetwork(Map<String, dynamic> data) {
    return WeatherModel(
      placeName: data['name'] as String,
      weather: "${(data['main']['temp'] - 273.15).floor()}°",
    );
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      placeName: map['placeName'] as String,
      weather: map['weather'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WeatherModel(placeName: $placeName, weather: $weather)';

  @override
  bool operator ==(covariant WeatherModel other) {
    if (identical(this, other)) return true;

    return other.placeName == placeName && other.weather == weather;
  }

  @override
  int get hashCode => placeName.hashCode ^ weather.hashCode;
}
