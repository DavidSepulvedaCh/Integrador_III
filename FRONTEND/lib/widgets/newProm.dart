// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NuevaPromo extends StatefulWidget {
  const NuevaPromo({super.key});

  @override
  State<NuevaPromo> createState() => _NuevaPromoState();
}

class _NuevaPromoState extends State<NuevaPromo> {
  static const negro = Color.fromARGB(193, 13, 14, 13);
  static const naranja = Colors.deepOrange;
  static const blanco = Colors.white;
  static const botones = Color.fromARGB(235, 230, 80, 35);

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blanco,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 80,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              "Nueva Promoción",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega una nueva promoción para tus clientes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/restaurantIndex');
            },
            icon: const Icon(
              Icons.save,
              size: 28,
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/restaurantIndex');
          },
          icon: const Icon(
            Icons.cancel,
            size: 28,
          ),
        ),
        backgroundColor: naranja,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Nombre del producto',
                  hintStyle: const TextStyle(color: negro),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.fastfood, color: naranja),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Descripcion del producto',
                  hintStyle: const TextStyle(color: negro),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.description, color: naranja),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Precio del producto',
                  hintStyle: const TextStyle(color: negro),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.monetization_on, color: naranja),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_image != null)
                  Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                  ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción al presionar el botón de subir imagen
                    _pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Subir imagen'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: botones,
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción al presionar el botón de tomar foto
                    _pickImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar foto'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: botones,
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
