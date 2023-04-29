import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integrador/routes/imports.dart';

class ProfileSettings extends StatefulWidget {
  String name;
  String description;
  String photo;
  ProfileSettings(
      {super.key,
      required this.name,
      required this.description,
      required this.photo});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  File? _image;
  bool _isModalOpen = false;
  bool _isDoingFetch = false;
  late String originalName;
  late String originalDescription;
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    originalName = widget.name;
    originalDescription = widget.description;
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      if(pickedImage != null){
        _image = File(pickedImage.path);
      }
    });
  }

  void updatePhoto() async {
    if(_image == null){
      return;
    }
    String url = await Functions.uploadImageToCloudinary(_image!) ?? "";
    if(url == ""){
      return;
    }
    APIService.updateRestaurantPhoto(url)
        .then((value) => {
              if (value)
                {
                  setState(() {
                    _image = null;
                    widget.photo = url;
                  }),
                  CustomShowDialog.make(
                      context, "Éxito", "Se actualizó la foto exitosamente")
                }
              else
                {
                  CustomShowDialog.make(
                      context, "Error", "No se pudo actualizar la foto")
                }
            })
        .then((value) => {
              setState(() {
                _isDoingFetch = false;
              })
            });
  }

  void updateName() {
    if (nameController.text == originalName) {
      return;
    }
    setState(() {
      _isDoingFetch = true;
    });
    APIService.updateRestaurantName(nameController.text)
        .then((value) => {
              if (value)
                {
                  setState(() {
                    originalName = nameController.text;
                  }),
                  CustomShowDialog.make(
                      context, "Éxito", "Se actualizó el nombre exitosamente")
                }
              else
                {
                  CustomShowDialog.make(
                      context, "Error", "No se pudo actualizar el nombre")
                }
            })
        .then((value) => {
              setState(() {
                _isDoingFetch = false;
              })
            });
  }

  void updateDescription() {
    if (descriptionController.text == originalDescription) {
      return;
    }
    APIService.updateRestaurantDescription(descriptionController.text)
        .then((value) => {
              if (value)
                {
                  setState(() {
                    originalDescription = descriptionController.text;
                  }),
                  CustomShowDialog.make(context, "Éxito",
                      "Se actualizó la descripción exitosamente")
                }
              else
                {
                  CustomShowDialog.make(
                      context, "Error", "No se pudo actualizar la descripción")
                }
            })
        .then((value) => {
              setState(() {
                _isDoingFetch = false;
              })
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
              child: const Text('Camara',
                  style: TextStyle(color: Colors.deepOrange)),
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
              child: const Text('Galeria',
                  style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: _isDoingFetch,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.deepOrange,
                title: const Text('Editar perfil'),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
                                    : CachedNetworkImageProvider(widget.photo)
                                        as ImageProvider<Object>),
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
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu nombre',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: updateName,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.name = value;
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
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: "Ingresa tu descripción",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: updateDescription,
                          ),
                        ),
                        maxLines: null,
                        onChanged: (value) {
                          setState(() {
                            widget.description = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: updatePhoto,
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
              )),
        ),
        if (_isDoingFetch)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
