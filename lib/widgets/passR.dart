import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget buildPasswordRep() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Repetir contreña',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 15),
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
                color: Colors.black38, blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        height: 60,
        child: TextField(
          obscureText: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 15),
              prefixIcon: Icon(Icons.lock, color: HexColor('#E64A19')),
              hintText: 'Repite la contraseña',
              hintStyle: TextStyle(color: HexColor('#212121'))),
        ),
      )
    ],
  );
}
