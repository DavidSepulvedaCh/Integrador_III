import 'package:flutter/material.dart';
import 'widgets/oferta.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.orangeAccent),
          toolbarHeight: 75,
          title: const Text(
            'FoodHub',
            style: TextStyle(color: Colors.orangeAccent),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/restaurantelogin');
              },
              icon: const Icon(Icons.login),
            )
          ],
          leading: IconButton(
              onPressed: () {}, icon: const Icon(Icons.replay_outlined)),
          backgroundColor: Colors.black),
      body: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return const Oferta();
          }),
    );
  }
}
