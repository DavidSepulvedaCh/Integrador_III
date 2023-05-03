// ignore_for_file: must_be_immutable, prefer_final_fields

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:integrador/routes/imports.dart';

class ProfileSettings extends StatefulWidget {
  String name;
  String description;
  String photo;
  final Function(bool) update;
  ProfileSettings(
      {super.key,
      required this.name,
      required this.description,
      required this.photo,
      required this.update});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  File? _image;
  // ignore: unused_field
  bool _isModalOpen = false;
  bool _isDoingFetch = false;
  late String originalName;
  late String originalDescription;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  bool isSaveIconVisible = false;
  bool isDescription = false;
  bool isImg = false;

  @override
  void initState() {
    super.initState();
    originalName = widget.name;
    originalDescription = widget.description;
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
    nameController.addListener(() {
      setState(() {
        isSaveIconVisible = nameController.text != originalName;
      });
    });
    descriptionController.addListener(() {
      setState(() {
        isDescription = nameController.text != originalName ||
            descriptionController.text != originalDescription;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        isImg = true;
      }
    });
  }

  void updatePhoto() async {
    if (_image == null) {
      return;
    }
    setState(() {
      _isDoingFetch = true;
    });
    String url = await Functions.uploadImageToCloudinary(_image!) ?? "";
    if (url == "") {
      return;
    }
    APIService.updatePhoto(url)
        .then((value) => {
              if (value)
                {
                  setState(() {
                    _image = null;
                    widget.photo = url;
                  }),
                  CustomShowDialog.make(
                      context, "Éxito", "Se actualizó la foto exitosamente"),
                  widget.update(true)
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
                      context, "Éxito", "Se actualizó el nombre exitosamente"),
                  widget.update(true)
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
    setState(() {
      _isDoingFetch = true;
    });
    APIService.updateRestaurantDescription(descriptionController.text)
        .then((value) => {
              if (value)
                {
                  setState(() {
                    originalDescription = descriptionController.text;
                  }),
                  CustomShowDialog.make(context, "Éxito",
                      "Se actualizó la descripción exitosamente"),
                  widget.update(true)
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
                    isImg = true;
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
                      Container(
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
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepOrange,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    showModal();
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepOrange,
                                ),
                                child: Visibility(
                                  visible: isImg != false,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.save,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                          suffixIcon: Visibility(
                            visible: isSaveIconVisible,
                            child: IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () {
                                if (nameController.text == originalName) {
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Confirmación actualizar nombre'),
                                      content: const Text(
                                          '¿Estas seguro de actualizar el nombre?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Aceptar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            updateName();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
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
                          suffixIcon: Visibility(
                            visible: isDescription,
                            child: IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () {
                                if (descriptionController.text ==
                                    originalDescription) {
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Confirmación actualizar descripción'),
                                      content: const Text(
                                          '¿Estas seguro de actualizar la descripción?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Aceptar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            updateDescription();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 20),
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
