import 'package:app_vendedor/exports.dart';
import 'package:local_auth/local_auth.dart';

class PerfilRestaurante extends StatefulWidget {
  const PerfilRestaurante({super.key});

  @override
  State<PerfilRestaurante> createState() => _PerfilRestauranteState();
}

class _PerfilRestauranteState extends State<PerfilRestaurante> {
  final storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  late bool usingBiometric;
  String btnText = '';

  @override
  void initState() {
    isUsingBiometric();
    super.initState();
  }

  void isUsingBiometric() async {
    final biometric = await SecureStorageService.isUsingBiometric2();
    setState(() {
      usingBiometric = biometric;
    });
  }

  void desactivar(BuildContext context) async {
    final res = await APIservice.removeBiometric();
    if (res) {
      setState(() {
        usingBiometric = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (usingBiometric) {
      btnText = 'Deshabilitar datos biométricos';
    } else {
      btnText = 'Habilitar datos biométricos';
    }
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 75,
        centerTitle: true,
        title: const Text(
          'Editar datos',
          style: TextStyle(color: Colors.orangeAccent),
        ),
        actions: [
          IconButton(
              color: Colors.orangeAccent,
              onPressed: () async {
                Navigator.pushNamed(context, '/restaurantehome');
              },
              icon: const Icon(Icons.save))
        ],
        leading: IconButton(
            color: Colors.orangeAccent,
            onPressed: () {
              Navigator.pushNamed(context, '/restaurantehome');
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'ejemplo@correo.com',
                    labelText: 'Correo electrónico'),
              ),
            ),
            const SizedBox(height: 20),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: const TextField(
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  decoration: InputDecoration(
                      icon: Icon(Icons.password),
                      hintText: 'password',
                      labelText: 'Contraseña'),
                )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    hintText: 'Ubicación',
                    labelText: 'Ubicación'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  bool touchID = await auth.authenticate(
                      localizedReason: 'Por favor, confirma tu identidad');
                  // ignore: use_build_context_synchronously
                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          ((BuildContext context, StateSetter setState) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            TextField(
                              controller: emailTextController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Correo',
                                  hintText: 'daniel_patino@gmail.com'),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: passwordTextController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Contraseña',
                                  hintText: 'pruebaPassword'),
                              obscureText: true,
                            ),
                            ElevatedButton(
                              child: const Text('Aceptar'),
                              onPressed: () {
                                if (usingBiometric) {
                                  submit(emailTextController.text,
                                      passwordTextController.text);
                                  storage.write(
                                      key: 'biometricToken', value: null);
                                } else {
                                  submitFP(emailTextController.text,
                                      passwordTextController.text);
                                }
                              },
                            ),
                          ],
                        );
                      }));
                    },
                  );
                },
                child: Text(btnText)),
          ],
        ),
      ),
    );
  }

  void registerFingerPrint(String email, String password) async {
    int response = await APIservice.biometricRegister(email, password);
    if (response == 1) {
      setState(() {
        usingBiometric = (response == 1);
      });
    }
  }

  void submit(email, password) async {
    LoginRequestModel model =
        LoginRequestModel(email: email, password: password);
    final response = await APIservice.login(model);
    if (response == 0) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/restaurantehome');
    } else if (response == 1) {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(
          context, 'Error', 'Usuario o contraseña incorrecta');
    } else {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(
          context, 'Error', 'Ocurrió un error. Intente más tarde');
    }
  }

  void submitFP(email, password) async {
    LoginRequestModel model =
        LoginRequestModel(email: email, password: password);
    final response = await APIservice.login(model);
    if (response == 0) {
      registerFingerPrint(email, password);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/restaurantehome');
    } else if (response == 1) {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(
          context, 'Error', 'Usuario o contraseña incorrecta');
    } else {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(
          context, 'Error', 'Ocurrió un error. Intente más tarde');
    }
  }
}
