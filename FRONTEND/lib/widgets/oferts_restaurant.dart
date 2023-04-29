import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class OfertaRestaurante extends StatelessWidget {
  Function removeOffer;
  String id;
  String title;
  String restaurantName;
  String description;
  String photo;
  double price;

  OfertaRestaurante(
      {super.key,
      required this.removeOffer,
      required this.id,
      required this.title,
      required this.restaurantName,
      required this.description,
      required this.photo,
      required this.price});

  static const titleColor = Color.fromARGB(209, 31, 32, 31);
  static const descriptionColor = Color.fromARGB(255, 34, 34, 34);
  static const restaurantColor = Color.fromARGB(218, 65, 65, 65);
  static const priceColor = Color.fromARGB(255, 197, 101, 10);
  static const deleteColor = Color.fromARGB(255, 36, 36, 35);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: photo,
                  width: 115,
                  height: 115,
                  placeholder: (context, url) => const SpinKitRing(
                    color: Colors.deepOrange,
                    size: 50.0,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: titleColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.justify,
                    maxLines: 2, // Limita el texto a dos líneas
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 200, // Ancho máximo para el widget Text
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: descriptionColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 2, // Limita el texto a dos líneas
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  restaurantName,
                  style: const TextStyle(
                    color: restaurantColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "\$ ${price.toString()}",
                  style: const TextStyle(
                    color: priceColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('¡Eliminar $title!'),
                          content: const Text(
                              '¿Estas seguro de eliminar esta oferta?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Aceptar'),
                              onPressed: () {
                                removeOffer(id);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  color: deleteColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
