// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:integrador/routes/imports.dart';

class NuevaPromo extends StatefulWidget {
  final Function(bool) createOffer;
  const NuevaPromo({super.key, required this.createOffer});

  @override
  State<NuevaPromo> createState() => _NuevaPromoState();
}

class _NuevaPromoState extends State<NuevaPromo> {
  static const naranja = Colors.deepOrange;
  static const blanco = Colors.white;
  static const botones = Color.fromARGB(235, 230, 80, 35);

  bool _isDoingFetch = false;
  File? _image;
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  final RegExp _formatter = RegExp(r'^\d*\.?\d{0,4}$');

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    price.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
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
    return true;
  }

  void createOffer() async {
    if (!_validate()) {
      return;
    }
    setState(() {
      _isDoingFetch = true;
    });
    String? imageUrl = await Functions.uploadImageToCloudinary(_image!);
    await APIService.createOffer(
            name.text, description.text, price.text, imageUrl!)
        .then((value) => {
              if (value)
                {
                  FocusScope.of(context).unfocus(),
                  widget.createOffer(true),
                  CustomShowDialog.make(
                          context, "Éxito", "Se creó la oferta correctamente")
                      .then((value) => Navigator.pop(context))
                }
              else
                {
                  CustomShowDialog.make(
                      context, "Error", "No se pudo crear la oferta")
                }
            });
    setState(() {
      _isDoingFetch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: _isDoingFetch,
          child: Scaffold(
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmar creación de oferta'),
                            content: const Text(
                                '¿Estas seguro de crear esta nueva oferta?'),
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
                                  createOffer();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.save,
                      size: 28,
                    ),
                  ),
                ],
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(top: 15),
                                    prefixIcon: Icon(Icons.monetization_on,
                                        color: HexColor('#E64A19')),
                                    hintText: "Precio del producto",
                                    hintStyle:
                                        TextStyle(color: HexColor('#212121'))),
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
