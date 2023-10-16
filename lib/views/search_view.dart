import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab3/models/weather_model.dart';
import 'package:lab3/utils/utils.dart';
import 'package:lab3/widgets/weather_widget.dart';

import 'map/cubit/map_view_cubit.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final Debouncer debouncer = Debouncer(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViewCubit, MapViewState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (String value) {
                  debouncer.run(() {
                    BlocProvider.of<MapViewCubit>(context).searchWeather(value);
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Type city name ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        25,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leadingWidth: double.infinity,
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              ...state.searchList.map((WeatherModel el) {
                return WeatherWidget(
                  data: el,
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
