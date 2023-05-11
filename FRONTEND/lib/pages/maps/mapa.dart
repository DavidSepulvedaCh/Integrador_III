// ignore_for_file: unused_element, deprecated_member_use, use_build_context_synchronously

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
  Position? currentLocation;
  double lati = 0.0000;
  double long = 0.0000;

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

  Future<LatLng> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  void _createMarkers(List<Restaurant> restaurants) {
    for (final restaurant in restaurants) {
      final marker = Marker(
        markerId: MarkerId(restaurant.id!),
        position: LatLng(
          double.parse(restaurant.latitude!),
          double.parse(restaurant.longitude!),
        ),
        infoWindow: InfoWindow(title: restaurant.name!),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(restaurant.photo!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          restaurant.name!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            restaurant.description!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () async {
                            lati = double.parse(restaurant.latitude!);
                            long = double.parse(restaurant.longitude!);
                            final destino = LatLng(lati, long);
                            final origen = await _getCurrentLocation();
                            //const origen = LatLng(7.098191, -73.123305);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapaRutaWidget(
                                    origen: origen, destino: destino),
                              ),
                            );
                          },
                          // ignore: sort_child_properties_last
                          child: const Text(
                            "Ruta al restaurante",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
