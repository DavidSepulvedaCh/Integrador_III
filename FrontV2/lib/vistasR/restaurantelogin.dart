import 'package:flutter/material.dart';

class LoginRestaurante extends StatefulWidget {
  const LoginRestaurante({super.key});

  @override
  State<LoginRestaurante> createState() => _LoginRestauranteState();
}

class _LoginRestauranteState extends State<LoginRestaurante> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 75,
        centerTitle: true,
        title: const Text(
          'FoodHub',
          style: TextStyle(color: Colors.orangeAccent),
        ),
        leading: IconButton(
            color: Colors.orangeAccent,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'ejemplo@correo.com',
                    labelText: 'Correo electrónico'),
              ),
            ),
            const SizedBox(height: 20),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: const TextField(
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  decoration: InputDecoration(
                      icon: Icon(Icons.password),
                      hintText: 'password',
                      labelText: 'Contraseña'),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/restauranteregistro');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text(
                'Registrarse',
                style: TextStyle(color: Colors.orangeAccent),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/restaurantehome');
                },
                icon: const Icon(Icons.login))
          ],
        ),
      ),
    );
  }
}
