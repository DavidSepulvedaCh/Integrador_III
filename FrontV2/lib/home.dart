import 'package:flutter/material.dart';
import 'widgets/oferta.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const fondo = Color.fromARGB(192, 235, 235, 235);
  static const barraNavegacionColor = Color.fromARGB(255, 250, 140, 44);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        automaticallyImplyLeading: false, //btn retorceso
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 236, 248, 248)),
        toolbarHeight: 65, //altura del header
        elevation: 4,
        title: const Text(
          'FoodHub',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Navigator.pushNamed(context, '/restaurantelogin');
            },
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.replay_outlined),
          onPressed: () {},
        ),
        backgroundColor: barraNavegacionColor,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                'Bienvenido a FOODHUB, tu aplicación de ofertas en tiempo real en tu ciudad!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const Oferta();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
