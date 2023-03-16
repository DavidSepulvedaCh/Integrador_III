import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NuevaPromo extends StatefulWidget {
  const NuevaPromo({super.key});

  @override
  State<NuevaPromo> createState() => _NuevaPromoState();
}

class _NuevaPromoState extends State<NuevaPromo> {
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
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.orangeAccent),
          toolbarHeight: 75,
          title: const Text(
            'Nueva Promoción',
            style: TextStyle(color: Colors.orangeAccent),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/restaurantehome');
              },
              icon: const Icon(Icons.save),
            )
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/restaurantehome');
              },
              icon: const Icon(Icons.cancel)),
          backgroundColor: Colors.black),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: const TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    icon: Icon(Icons.fastfood), labelText: 'Nombre promoción'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: const TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    icon: Icon(Icons.description), labelText: 'Descripción'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(Icons.monetization_on), labelText: 'Precio'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                if (_image != null)
                  Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                  ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text('Seleccionar imagen de la galería'),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  child: const Text('Tomar foto'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
