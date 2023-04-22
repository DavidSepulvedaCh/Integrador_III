// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:integrador/routes/imports.dart';

import 'custom_show_dialog.dart';
import 'custom_text_field.dart';

final cloudinary = CloudinaryPublic('dti2zyzir', 'prueba');

Future<String?> uploadImageToCloudinary(File imageFile) async {
  try {
    final response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(imageFile.path),
    );

    return response.secureUrl;
  } catch (e) {
    print(e);
    return null;
  }
}

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
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  final RegExp _formatter = RegExp(r'^\d*\.?\d{0,4}$');

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  bool _validate() {
    if (name.text.isEmpty || description.text.isEmpty || price.text.isEmpty) {
      CustomShowDialog.make(context, "Falta llenar campos",
          "Debes llenar todos los campos para poder crear la oferta");
      return false;
    }
    if (!_formatter.hasMatch(price.text)) {
      CustomShowDialog.make(context, "Error", "Debes colocar un precio válido");
      return false;
    }
    if (_image == null) {
      CustomShowDialog.make(context, "Error", "No ha seleccionado imagen");
      return false;
    }
    print(_image.toString());
    return true;
  }

  void createOffer() async {
    if (!_validate()) {
      return;
    }
    String? imageUrl = await uploadImageToCloudinary(_image!);
    await APIService.createOffer(
            name.text, description.text, price.text, imageUrl!)
        .then((value) => {if (value) {
          CustomShowDialog.make(context, "Éxito", "Se creó la oferta correctamente").then((value) => Navigator.pushReplacementNamed(context, '/restaurantIndex'))
        }else{
          CustomShowDialog.make(context, "Error", "No se pudo crear la oferta")
        }});
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
            children: const [
              Text(
                "Nueva Promoción",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
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
              onPressed: () async {
                createOffer();
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
        body: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: CustomTextField(
                        textEditingController: name,
                        labelText: "",
                        hintText: "Nombre del producto",
                        icon: Icons.fastfood),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: CustomTextField(
                        textEditingController: description,
                        labelText: "",
                        hintText: "Descripción del producto",
                        icon: Icons.description),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 5,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        height: 60,
                        child: TextField(
                          controller: price,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 15),
                              prefixIcon: Icon(Icons.monetization_on,
                                  color: HexColor('#E64A19')),
                              hintText: "Precio del producto",
                              hintStyle: TextStyle(color: HexColor('#212121'))),
                        ),
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_image != null)
                        Image.file(
                          _image!,
                          width: 250,
                          height: 250,
                        ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                          SizedBox(width: 10),
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
                      SizedBox(height: 35)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
