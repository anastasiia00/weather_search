import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab3/views/map/map_view.dart';
import 'package:lab3/views/search_view.dart';

import 'map/cubit/map_view_cubit.dart';

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapViewCubit(),
      child: BlocBuilder<MapViewCubit, MapViewState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                _currentIndex == 0 ? const MapViewScreen() : SearchView(),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: CupertinoSegmentedControl(
                      children: const {
                        0: Text('Map'),
                        1: Text('Search'),
                      },
                      onValueChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      groupValue: _currentIndex,
                    ),
                  ),
                )
              ],
            ),
            floatingActionButton: _currentIndex == 0
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: FloatingActionButton(
                      onPressed: () async {
                        bool serviceEnabled;
                        LocationPermission permission;

                        serviceEnabled =
                            await Geolocator.isLocationServiceEnabled();
                        if (!serviceEnabled) {
                          return Future.error(
                              'Location services are disabled.');
                        }

                        permission = await Geolocator.checkPermission();
                        if (permission == LocationPermission.denied) {
                          permission = await Geolocator.requestPermission();
                          if (permission == LocationPermission.denied) {
                            return;
                          }
                        }

                        if (permission == LocationPermission.deniedForever) {
                          return;
                        }

                        final pos = await Geolocator.getCurrentPosition();
                        BlocProvider.of<MapViewCubit>(context)
                            .centerAndGetWeatherData(
                                pos.latitude, pos.longitude);
                      },
                      child: const Icon(Icons.my_location_rounded),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
