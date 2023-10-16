import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab3/utils/utils.dart';
import 'package:lab3/views/map/cubit/map_view_cubit.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({
    super.key,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Debouncer cameraDebouncer = Debouncer(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViewCubit, MapViewState>(
      builder: (context, state) {
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: state.cameraPos,
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                BlocProvider.of<MapViewCubit>(context).controller =
                    await _controller.future;
              },
              onCameraMove: (position) {
                cameraDebouncer.run(() {
                  BlocProvider.of<MapViewCubit>(context).setCameraPos(position);
                });
              },
              markers: state.markers ?? {},
              myLocationButtonEnabled: false,
              onLongPress: (LatLng latLng) async {
                await BlocProvider.of<MapViewCubit>(context)
                    .getWeatherData(latLng.latitude, latLng.longitude);
              },
            ),
            const Positioned(
              top: 80,
              left: 145,
              child: Text(
                'Location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
