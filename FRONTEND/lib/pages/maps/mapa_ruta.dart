import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapaRutaWidget extends StatefulWidget {
  final LatLng origen;
  final LatLng destino;

  const MapaRutaWidget({super.key, required this.origen, required this.destino});

  @override
  State<MapaRutaWidget> createState() => _MapaRutaWidgetState();
}

class _MapaRutaWidgetState extends State<MapaRutaWidget> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late LatLngBounds _bounds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) => _controller = controller,
        markers: _markers,
        polylines: _polylines,
        initialCameraPosition: CameraPosition(
          target: widget.origen,
          zoom: 13,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: const MarkerId('origen'),
      position: widget.origen,
      infoWindow: const InfoWindow(
        title: 'Origen',
      ),
    ));
    _markers.add(Marker(
      markerId: const MarkerId('destino'),
      position: widget.destino,
      infoWindow: const InfoWindow(
        title: 'Destino',
      ),
    ));
    _getRoute();
  }

  void _getRoute() async {
    String googleMapsApiKey = "AIzaSyCAdQh3u8eBv2ASDf_qh0e92al8TK_ETy4";
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.origen.latitude},${widget.origen.longitude}&destination=${widget.destino.latitude},${widget.destino.longitude}&mode=driving&key=$googleMapsApiKey';

    final response = await http.get(Uri.parse(url));

    final Map<String, dynamic> data = jsonDecode(response.body);

    List<LatLng> points = [];
    List<String> instructions = []; // Lista de instrucciones

    if (data['status'] == 'OK') {
      data['routes'][0]['legs'][0]['steps'].forEach((step) {
        points.add(LatLng(
            step['start_location']['lat'], step['start_location']['lng']));
        points.add(
            LatLng(step['end_location']['lat'], step['end_location']['lng']));

        // Extraer la instrucción de este paso y agregarla a la lista de instrucciones
        String instruction = step['html_instructions'];
        instruction =
            instruction.replaceAll('<b>', ''); // Eliminar las etiquetas HTML
        instruction = instruction.replaceAll('</b>', '');
        instruction =
            instruction.replaceAll('<div style="font-size:0.9em">', ' ');
        instruction = instruction.replaceAll('</div>', '');
        instructions.add(instruction.trim());
      });

      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: const Color.fromARGB(255, 243, 93, 33),
          width: 5,
        ));
      });

      _bounds = LatLngBounds(
        southwest: LatLng(
          data['routes'][0]['bounds']['southwest']['lat'],
          data['routes'][0]['bounds']['southwest']['lng'],
        ),
        northeast: LatLng(
          data['routes'][0]['bounds']['northeast']['lat'],
          data['routes'][0]['bounds']['northeast']['lng'],
        ),
      );

      // Declaración de la variable antes de ser utilizada
      GoogleMapController controller = _controller;

      controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds, 50));
    }
  }
}
