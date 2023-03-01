import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
        backgroundColor: MaterialStateProperty.all<Color>(HexColor('#E64A19')),
      ),
      onPressed: () => print('Accion'),
      child: const Text(
        'Ingresar',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
    ),
  );
}
