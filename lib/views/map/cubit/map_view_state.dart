part of 'map_view_cubit.dart';

class MapViewState {
  final Set<Marker>? markers;
  final bool isLoading;
  final CameraPosition cameraPos;
  final List<WeatherModel> searchList;

  MapViewState({
    this.markers,
    this.searchList = const [],
    this.isLoading = false,
    this.cameraPos = const CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    ),
  });

  MapViewState copyWith({
    Set<Marker>? markers,
    bool? isLoading,
    CameraPosition? cameraPos,
    List<WeatherModel>? searchList,
  }) {
    return MapViewState(
      markers: markers ?? this.markers,
      isLoading: isLoading ?? this.isLoading,
      cameraPos: cameraPos ?? this.cameraPos,
      searchList: searchList ?? this.searchList,
    );
  }
}
