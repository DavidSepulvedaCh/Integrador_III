// ignore_for_file: use_build_context_synchronously

import 'package:integrador/routes/imports.dart';
import 'package:http/http.dart' as http;

class RegisterRestaurant extends StatefulWidget {
  const RegisterRestaurant({super.key});

  @override
  State<RegisterRestaurant> createState() => _RegisterRestaurantState();
}

class _RegisterRestaurantState extends State<RegisterRestaurant> {
  static const box = Color.fromARGB(185, 99, 99, 99);

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

  Future<void> _getCurrentLocation() async {
    try {
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
      print('LOCATIONN ==>  $selectedLocation');
      print('CIUDAD!!! ==>  $selectedCity');
    } catch (e) {}
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
    const radius = 2000; // Definimos el radio de búsqueda en metros
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
    RegisterRequestModel model = RegisterRequestModel(
        name: nameTextController.text,
        email: emailTextController.text,
        password: passwordOneTextController.text);
    final response = await APIService.register(model);
    if (response == 0) {
      // ignore: use_build_context_synchronously
      await Functions.loginSuccess(context);
    } else if (response == 1) {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(context, 'Error', 'Email ya registrado');
    } else if (response == 2) {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(context, 'Error', 'No se pudo registrar el email');
    } else {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(
          context, 'Error', 'Ocurrió un error. Intente más tarde');
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginRestaurante()));
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
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSate) {
            return Container(
              height: 1000,
              width: 800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text("¡Elige la ubicacion de tu restaurante!"),
                      Text("Tu ubicación:  $selectedLocation"),
                      Text("Tu ciudad:  $selectedCity"),
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
                          setState(() async {
                            selectedLocation =
                                placePredictions[index].description!;
                            latit = location.latitude;
                            longit = location.longitude;
                            selectedLocationLatLng =
                                LatLng(location.latitude, location.longitude);
                            selectedCity = await getCityFromLocation(
                                location.latitude, location.longitude);
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
                          onPrimary: Colors.white,
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
                          });
                          print("LOCATIONN ==>  $selectedLocation");
                          print("CIUDAD!!! ==>  $selectedCity");
                        },
                        child: const Text('Utilizar mi ubicación'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          onPrimary: Colors.white,
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
              Container(
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
                          onPrimary: Colors.deepOrange,
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
            ],
          ),
        ),
      ),
    );
  }
}
