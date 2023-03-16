import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Oferta extends StatelessWidget {
  const Oferta({super.key});

  Future<void> abrirUrl(String sUrl) async {
    final Uri oUri = Uri.parse(sUrl);
    try {
      await launchUrl(oUri, mode: LaunchMode.externalApplication);
    } catch (oError) {
      return Future.error('No fue posible abrir la url: $sUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(width: 2)),
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 125,
              height: 125,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Promoción',
                    style: TextStyle(color: Colors.orangeAccent)),
                const Text('Descripción',
                    style: TextStyle(color: Colors.orangeAccent)),
                const Text('Restaurante',
                    style: TextStyle(color: Colors.orangeAccent)),
                const Text('Precio',
                    style: TextStyle(color: Colors.orangeAccent)),
                IconButton(
                  onPressed: () {
                    abrirUrl(
                        "http://www.google.com/maps/place/6.2502089,-75.5706711");
                  },
                  icon: const Icon(Icons.location_on),
                  color: Colors.orangeAccent,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
