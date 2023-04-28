import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String _name = 'David Leonardo';
  String _location = 'Bucaramanga, Santander';
  String _description = 'I love programming.';
  File? _image;
  bool _isModalOpen = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  void showModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('EDITAR FOTO DE PERFIL'),
          content: const Text('Editar foto de perfil desde:'),
          actions: [
            TextButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
              child: const Text('Camara', style: TextStyle(color: Colors.deepOrange)),
            ),
            TextButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 500,
                  maxHeight: 500,
                );
                if (image != null) {
                  setState(() {
                    _image = File(image.path);
                  });
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Galeria', style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: const Text('Editar perfil'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    showModal();
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _image != null
                            ? FileImage(_image!)
                            : const NetworkImage('https://bit.ly/3HjnEDk')
                                as ImageProvider<Object>,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepOrange,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nombre',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {},
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                const Text(
                  "Descripción",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    hintText: "Ingresa tu descripción",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.save,
                    size: 30,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: const Size(80, 50),
                  ),
                  label: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ));
  }
}
