// ignore_for_file: unused_element

import 'dart:async';
import 'package:integrador/routes/imports.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<Restaurant> restaurants = <Restaurant>[];
  final List<Marker> _markers = [];

// Lista de coordenadas con sus nombres

// Crear los marcadores a partir de la lista de coordenadas
  @override
  void initState() {
    super.initState();
    setRestaurantsInformation();
  }

  Future<void> setRestaurantsInformation() async {
    final List<Restaurant> restaurants = await getRestaurantsInformation();
    setState(() {
      _createMarkers(restaurants);
    });
  }

  Future<List<Restaurant>> getRestaurantsInformation() async {
    final register = await APIService.getInformationOfAllRestaurants();
    return register;
  }

  void _createMarkers(List<Restaurant> restaurants) {
    for (final restaurant in restaurants) {
      final marker = Marker(
        markerId: MarkerId(restaurant.id!),
        position: LatLng(double.parse(restaurant.latitude!),
            double.parse(restaurant.longitude!)),
        infoWindow: InfoWindow(title: restaurant.name!),
      );
      _markers.add(marker);
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // ignore: prefer_const_declarations
  static final CameraPosition _bucaramangaPosition = const CameraPosition(
    target: LatLng(7.119349, -73.122742),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            onPressed: () {
              for (var restaurant in restaurants) {
                print(restaurant.name);
              }
            },
            icon: const Icon(Icons.menu),
          )
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _bucaramangaPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_markers),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 15),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: _goToUserLocation,
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.my_location,
              color: Colors.deepOrange,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToUserLocation() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16);
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("Ubicación del usuario"),
          position: latLng,
          infoWindow: const InfoWindow(title: "Tu ubicación actual"),
        ),
      );
    });
  }
}
