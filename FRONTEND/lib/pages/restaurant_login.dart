// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginRestaurante extends StatefulWidget {
  const LoginRestaurante({super.key});

  @override
  State<LoginRestaurante> createState() => _LoginRestauranteState();
}

class _LoginRestauranteState extends State<LoginRestaurante> {
  static const fondo = Color.fromARGB(192, 235, 235, 235);
  static const barraNavegacionColor = Color.fromARGB(255, 250, 140, 44);
  static const backContainer = Color.fromARGB(181, 29, 29, 29);
  static const backBoxS = Color.fromARGB(80, 226, 207, 191);

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Correo electronico',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backContainer,
            borderRadius: BorderRadius.circular(10),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                  color: backBoxS, blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 15),
                prefixIcon:
                    Icon(Icons.email, color: Color.fromARGB(255, 245, 99, 14)),
                hintText: 'Dirección de correo',
                hintStyle: const TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Contreña',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backContainer,
            borderRadius: BorderRadius.circular(10),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                  color: backBoxS, blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          height: 60,
          // ignore: prefer_const_constructors
          child: TextField(
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 15),
                prefixIcon: const Icon(Icons.lock,
                    color: Color.fromARGB(255, 245, 99, 14)),
                hintText: 'Contraseña',
                hintStyle: const TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }

  Widget buildBtnSingUp() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/restauranteregistro');
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "¿No tienes una cuenta?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w100),
            ),
            TextSpan(
              text: " Registrate!",
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBtnLogin() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          minimumSize:
              MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
          backgroundColor:
              MaterialStateProperty.all<Color>(HexColor('#E64A19')),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/restaurantIndex');
        },
        child: const Text(
          'Ingresar',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('loginVendedor.jpg'),
                      fit: BoxFit.cover),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 45,
                    vertical: 90,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Inicio de Sesión',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Open Sans'),
                          ),
                          const SizedBox(height: 48),
                          buildEmail(),
                          const SizedBox(height: 48),
                          buildPassword(),
                          const SizedBox(height: 25),
                          buildBtnLogin(),
                          buildBtnSingUp(),
                        ],
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () {
                            Navigator.pushNamed(context, '/index');
                          },
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
