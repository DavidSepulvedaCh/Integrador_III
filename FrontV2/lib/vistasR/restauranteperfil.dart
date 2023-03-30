import 'package:app_vendedor/exports.dart';
import 'package:local_auth/local_auth.dart';

class PerfilRestaurante extends StatefulWidget {
  const PerfilRestaurante({super.key});

  @override
  State<PerfilRestaurante> createState() => _PerfilRestauranteState();
}

class _PerfilRestauranteState extends State<PerfilRestaurante> {
  final storage = FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
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
                if (_isChecked == true) {
                  bool touchID = await auth.authenticate(
                      localizedReason: 'Por favor, confirma tu identidad');
                  if (touchID) {
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
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Correo',
                                    hintText: 'daniel_patino@gmail.com'),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Contraseña',
                                    hintText: 'pruebaPassword'),
                                obscureText: true,
                              ),
                              ElevatedButton(
                                child: const Text('Aceptar'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/restaurantehome');
                                },
                              ),
                            ],
                          );
                        }));
                      },
                    );
                  }

                  storage.write(key: 'usingBiometric', value: 'true');
                  print('SI');
                } else {
                  storage.write(key: 'usingBiometric', value: 'false');
                  print('NO');
                  Navigator.pushNamed(context, '/restaurantehome');
                }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      _isChecked = newValue!;
                    });
                  },
                ),
                const Text('Habilitar inicio de sesión con huella')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
