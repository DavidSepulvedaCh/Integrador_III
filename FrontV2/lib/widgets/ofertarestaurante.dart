import 'package:flutter/material.dart';

class OfertaRestaurante extends StatelessWidget {
  const OfertaRestaurante({super.key});

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
          children: [
            const SizedBox(
              width: 100,
              height: 100,
            ),
            Expanded(
                child: Column(
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
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  color: Colors.orangeAccent,
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
