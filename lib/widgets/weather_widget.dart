// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lab3/models/weather_model.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final WeatherModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.purple[200], borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.placeName,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '${data.weather} ℃',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
