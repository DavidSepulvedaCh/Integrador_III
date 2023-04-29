// ignore_for_file: unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<Marker> _markers = [];

// Lista de coordenadas con sus nombres
  List<Map<String, dynamic>> coordinatesList = [
    {"name": "Lugar 1", "latitude": 7.119349, "longitude": -73.122742},
    {"name": "Lugar 2", "latitude": 7.118678, "longitude": -73.119956},
    {"name": "Lugar 3", "latitude": 7.111902, "longitude": -73.120012},
  ];

// Crear los marcadores a partir de la lista de coordenadas
  void _createMarkers() {
    for (final coordinates in coordinatesList) {
      final marker = Marker(
        markerId: MarkerId(coordinates["name"]),
        position: LatLng(coordinates["latitude"], coordinates["longitude"]),
        infoWindow: InfoWindow(title: coordinates["name"]),
      );
      _markers.add(marker);
    }
  }

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // ignore: prefer_const_declarations
  static final CameraPosition _bucaramangaPosition = const CameraPosition(
    target: LatLng(7.119349, -73.122742),
    zoom: 30,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa"),
        backgroundColor: Colors.deepOrange,
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
      _markers.clear();
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
