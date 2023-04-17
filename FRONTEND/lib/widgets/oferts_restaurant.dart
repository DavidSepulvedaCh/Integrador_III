import 'package:flutter/material.dart';

class OfertaRestaurante extends StatelessWidget {
  const OfertaRestaurante({super.key});

  static const titulo = Color.fromARGB(209, 31, 32, 31);
  static const descripcion = Color.fromARGB(255, 34, 34, 34);
  static const restaurante = Color.fromARGB(218, 65, 65, 65);
  static const precio = Color.fromARGB(255, 197, 101, 10);
  static const borrar = Color.fromARGB(255, 36, 36, 35);

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
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://bit.ly/3mTInGh',
                width: 115,
                height: 115,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 220,
                  child: Text(
                    'Hamburguesa especial 2x1 prueba titulo largo lorem ipsumn',
                    style: TextStyle(
                        color: titulo,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.justify,
                    maxLines: 2, // Limita el texto a dos líneas
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 5),
                const SizedBox(
                  width: 200, // Ancho máximo para el widget Text
                  child: Text(
                    'Combo de hamburguesas 2x1 + gaseosas de 300ml',
                    style: TextStyle(
                      color: descripcion,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 2, // Limita el texto a dos líneas
                    overflow: TextOverflow.ellipsis,
                  ),
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
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                  color: borrar,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
