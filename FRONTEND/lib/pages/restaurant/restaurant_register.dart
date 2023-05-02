// ignore_for_file: use_build_context_synchronously

import 'package:integrador/routes/imports.dart';
import 'package:http/http.dart' as http;

class RegisterRestaurant extends StatefulWidget {
  const RegisterRestaurant({super.key});

  @override
  State<RegisterRestaurant> createState() => _RegisterRestaurantState();
}

class _RegisterRestaurantState extends State<RegisterRestaurant> {
  bool _isDoingFetch = false;
  bool terminos = false;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordOneTextController = TextEditingController();
  TextEditingController passwordTwoTextController = TextEditingController();

  static const String apiKey = "AIzaSyCAdQh3u8eBv2ASDf_qh0e92al8TK_ETy4";
  String? selectedLocation;
  LatLng? selectedLocationLatLng;

  List<AutocompletePrediction> placePredictions = [];
  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      '/maps/api/place/autocomplete/json',
      {"input": query, "components": "country:co", "key": apiKey},
    );
    String? response = await NetworkUtiliti.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  Position? currentLocation;
  double latit = 00.0;
  double longit = -0.00;
  String? selectedCity;
  final List<String> _allowedCities = [
    "Girón",
    "Bucaramanga",
    "Floridablanca",
    "Piedecuesta"
  ];

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ubicación desactivada'),
            content: const Text('Por favor, active la ubicación para continuar.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar', style: TextStyle(color: Colors.deepOrange)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Aceptar', style: TextStyle(color: Colors.deepOrange)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );
      if (!result) {
        return Future.error('Location services are disabled.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        bool result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Permiso de ubicación denegado'),
              content: const Text(
                  'Por favor, otorgue el permiso de ubicación para continuar.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar', style: TextStyle(color: Colors.deepOrange)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Aceptar', style: TextStyle(color: Colors.deepOrange)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        );
        if (!result) {
          return Future.error('Location permissions are denied');
        }
      }
    }

    try {
      // Obtener la ubicación actual del usuario
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = position;
        selectedLocation = '${position.latitude}, ${position.longitude}';
        selectedLocationLatLng = LatLng(position.latitude, position.longitude);
        latit = position.latitude;
        longit = position.longitude;
      });
      selectedCity =
          await getCityFromLocation(position.latitude, position.longitude);
    } catch (e) {
      e.toString();
    }
  }

  Future<Location> getLocationFromAddress(String address) async {
    final query = Uri.encodeQueryComponent(address);
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'] as List<dynamic>;

      if (results.isNotEmpty) {
        final locationJson = results[0]['geometry']['location'];
        return Location(
          latitude: locationJson['lat'] as double,
          longitude: locationJson['lng'] as double,
          timestamp: DateTime.now(),
        );
      }
    }

    throw Exception(
        'No se pudo obtener la ubicación de la dirección especificada.');
  }

  Future<String?> getCityFromLocation(double latitude, double longitude) async {
    const radius = 5000; // Definimos el radio de búsqueda en metros
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=locality&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final results = jsonResponse['results'];
      if (results.isNotEmpty) {
        return results[0]['name'];
      }
    }

    return null;
  }

  void register() async {
    if (!Functions.validateRegister(
        context,
        nameTextController.text,
        emailTextController.text,
        passwordOneTextController.text,
        passwordTwoTextController.text,
        terminos)) {
      return;
    }
    if (!_allowedCities.contains(selectedCity)) {
      CustomShowDialog.make(
          context, "Error", "Ciudad no válida para uso de la aplicación");
      return;
    }
    RegisterRequestModel model = RegisterRequestModel(
        name: nameTextController.text,
        email: emailTextController.text,
        password: passwordOneTextController.text);
    if (selectedLocation == null || selectedCity == null) {
      CustomShowDialog.make(
          context, "Error", "No se ha podido obtener la ubicación");
      return;
    }
    setState(() {
      _isDoingFetch = true;
    });
    final response = await APIService.registerRestaurant(model,
        latit.toString(), longit.toString(), selectedLocation!, selectedCity!);
    if (response == 0) {
      Navigator.pushReplacementNamed(context, "/restaurantIndex");
    } else if (response == 1) {
      CustomShowDialog.make(context, 'Error', 'Email ya registrado');
      setState(() {
        _isDoingFetch = false;
      });
    } else if (response == 2) {
      CustomShowDialog.make(context, 'Error', 'No se pudo registrar el email');
      setState(() {
        _isDoingFetch = false;
      });
    } else {
      CustomShowDialog.make(
          context, 'Error', 'Ocurrió un error. Intente más tarde');
      setState(() {
        _isDoingFetch = false;
      });
    }
  }

  Widget builTerminos() {
    return SizedBox(
      height: 20,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: terminos,
              checkColor: Colors.grey,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  terminos = value!;
                });
              },
            ),
          ),
          const Text(
            'Acepto los terminos y condiciones.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget buildBtnSingIn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Login()));
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "¿Ya tienes una cuenta?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w100),
            ),
            TextSpan(
              text: " Ingresa!",
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

  Future<String?> getAddress(double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final results = jsonResponse['results'];
      if (results.isNotEmpty) {
        return selectedLocation = results[0]['formatted_address'];
      }
    }

    return null;
  }

  void abrirModal() {
    showModalBottomSheet(
      context: context,
      //isScrollControlled: true,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSate) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.70,
              width: 800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 25),
                      const Text(
                        "¡Elige la ubicacion de tu restaurante!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text.rich(
                          TextSpan(
                            text: "Tu ubicación:  ",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .deepOrange, // Aplica el color solo al primer TextSpan
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "$selectedLocation",
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors
                                      .black, // Color de texto predeterminado
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Text.rich(
                          TextSpan(
                            text: "Tu ciudad:  ",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .deepOrange, // Aplica el color solo al primer TextSpan
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "$selectedCity",
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors
                                      .black, // Color de texto predeterminado
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          placeAutocomplete(value);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Buscar ubicación',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) => LocationListTile(
                        press: () async {
                          final location = await getLocationFromAddress(
                              placePredictions[index].description!);
                          setState(() {
                            selectedLocation =
                                placePredictions[index].description!;
                            selectedLocationLatLng =
                                LatLng(location.latitude, location.longitude);
                            latit = location.latitude;
                            longit = location.longitude;
                          });
                          await getCityFromLocation(
                                  location.latitude, location.longitude)
                              .then((value) => {
                                    setState(() {
                                      if (value == null) {
                                        List<String> miArray =
                                            placePredictions[index]
                                                .description!
                                                .split(", ");
                                        if (miArray.elementAt(
                                                miArray.length - 2) ==
                                            "Bogotá") {
                                          selectedCity = miArray
                                              .elementAt(miArray.length - 2);
                                        } else {
                                          selectedCity = miArray
                                              .elementAt(miArray.length - 3);
                                        }
                                      } else {
                                        selectedCity = value;
                                      }
                                    })
                                  });
                          Navigator.pop(context);
                        },
                        location: placePredictions[index].description!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                          padding: const EdgeInsets.symmetric(
                              vertical: 17, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedLocation;
                            selectedCity;
                            _getCurrentLocation();
                            getAddress(latit, longit);
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Utilizar mi ubicación'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                          padding: const EdgeInsets.symmetric(
                              vertical: 17, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedLocation;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
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
              IgnorePointer(
                ignoring: _isDoingFetch,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/signUpRest.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                      vertical: 50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Registra tu restaurante',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Open Sans'),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Regístrate ahora y comienza a disfrutar de todos los beneficios de nuestra plataforma.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Open Sans'),
                        ),
                        const SizedBox(height: 48),
                        CustomTextField(
                            textEditingController: nameTextController,
                            labelText: 'Nombre del restaurante',
                            hintText: 'Nombre del restaurante',
                            icon: Icons.local_restaurant_outlined),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.location_on),
                          label: Text(
                            selectedLocation ?? 'Ubicación del Restaurante',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepOrange,
                            textStyle: const TextStyle(fontSize: 16),
                            padding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedLocation;
                              abrirModal();
                            });
                          },
                        ),
                        const SizedBox(height: 35),
                        CustomTextField(
                            textEditingController: emailTextController,
                            labelText: 'Correo electrónico',
                            hintText: 'Dirección de correo',
                            icon: Icons.email),
                        const SizedBox(height: 30),
                        PasswordField(
                            textEditingController: passwordOneTextController,
                            labelText: 'Contraseña',
                            hintText: 'Contraseña'),
                        const SizedBox(height: 30),
                        PasswordField(
                            textEditingController: passwordTwoTextController,
                            labelText: 'Repite la contraseña',
                            hintText: 'Repite la contraseña'),
                        const SizedBox(height: 15),
                        builTerminos(),
                        const SizedBox(height: 20),
                        ButtonOne(onClick: register, text: 'Registrar'),
                        buildBtnSingIn()
                      ],
                    ),
                  ),
                ),
              ),
              if (_isDoingFetch)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
