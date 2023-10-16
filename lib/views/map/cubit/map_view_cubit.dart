import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab3/models/weather_model.dart';
import 'package:lab3/views/map/map_sevice.dart';

import 'package:http/http.dart' as http;
part 'map_view_state.dart';

class MapViewCubit extends Cubit<MapViewState> {
  MapViewCubit() : super(MapViewState());

  final MapService mapService = MapService();
  final weatherApiKey = '40c52101e5e4afab26bb3c73ec697468';
  final apiKey = "AIzaSyDchzmphiCIZVQD3o7W-wrq3z2yy-uPWFY";
  GoogleMapController? controller;

  Future<void> init(String chckId) async {
    emit(state.copyWith(isLoading: true));

    emit(state.copyWith(isLoading: false));
  }

  Future<void> getWeatherData(
    double lat,
    double lon,
  ) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$weatherApiKey'));

    if (response.statusCode == 200) {
      final data = WeatherModel.fromNetwork(
        json.decode(response.body),
      );
      final MarkerId markerId = MarkerId(LatLng(lat, lon).toString());
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lon),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: data.placeName,
          snippet: data.weather,
        ),
        onTap: () {},
      );

      emit(state.copyWith(markers: {
        if (state.markers != null) ...state.markers!,
        marker,
      }));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String?> _getCityName(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      return placemarks[0].locality;
    } else {
      return 'Не удалось определить город';
    }
  }

  Future<void> centerAndGetWeatherData(
    double latitude,
    double longitude,
  ) async {
    await getWeatherData(latitude, longitude);
    setCameraPos(CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 19.151926040649414,
    ));
  }

  void setCameraPos(CameraPosition position) async {
    await controller?.moveCamera(
      CameraUpdate.newCameraPosition(
        position,
      ),
    );
    emit(state.copyWith(
      cameraPos: position,
    ));
  }

  void searchWeather(String value) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$value&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == "OK") {
        final response = await http.get(Uri.parse(// TODO: хз че тут про ключу
            'https://api.openweathermap.org/data/2.5/onecall?lat=${data['results'][0]['geometry']['location']['lat']}&lon=${data['results'][0]['geometry']['location']['lng']}&exclude=current,minutely,hourly&appid=$weatherApiKey'));
        print(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
