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

  static const titulo = Color.fromARGB(255, 13, 14, 13);
  static const descripcion = Color.fromARGB(255, 34, 34, 34);
  static const restaurante = Color.fromARGB(218, 65, 65, 65);
  static const precio = Color.fromARGB(255, 197, 101, 10);
  static const ubicacion = Color.fromARGB(255, 185, 109, 10);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(width: 2, color: Colors.transparent),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://bit.ly/3mTInGh',
                width: 125,
                height: 125,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hamburguesa especial 2x1',
                  style: TextStyle(
                      color: titulo, fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Combo de hamburguesas 2x1 + gaseosas',
                  style: TextStyle(
                    color: descripcion,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                const Text(
                  'Comics Pizaa',
                  style: TextStyle(
                    color: restaurante,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '20.000 COP',
                  style: TextStyle(
                    color: precio,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () {
                    abrirUrl(
                        "http://www.google.com/maps/place/6.2502089,-75.5706711");
                  },
                  color: ubicacion,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
