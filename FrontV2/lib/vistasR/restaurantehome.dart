import 'package:app_vendedor/exports.dart';
import 'package:flutter/material.dart';
import '../widgets/ofertarestaurante.dart';

class HomeRestaurante extends StatelessWidget {
  const HomeRestaurante({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 75,
        centerTitle: true,
        title: const Text(
          'Restaurante',
          style: TextStyle(color: Colors.orangeAccent),
        ),
        actions: [
          IconButton(
              color: Colors.orangeAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/restauranteperfil');
              },
              icon: const Icon(Icons.settings))
        ],
        leading: IconButton(
            color: Colors.orangeAccent,
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout)),
      ),
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return const OfertaRestaurante();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/nuevapromocion');
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  void logout(context) {
    Shared.prefs.clear();
    Navigator.pushNamed(context, '/home');
  }
}
