import 'package:flutter/material.dart';
import '/exports.dart';

class RegistroRestaurante extends StatefulWidget {
  const RegistroRestaurante({super.key});

  @override
  State<RegistroRestaurante> createState() => _RegistroRestauranteState();
}

class _RegistroRestauranteState extends State<RegistroRestaurante> {
  final storage = FlutterSecureStorage();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 75,
        centerTitle: true,
        title: const Text(
          'FoodHub',
          style: TextStyle(color: Colors.orangeAccent),
        ),
        leading: IconButton(
            color: Colors.orangeAccent,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.orangeAccent,
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
            IconButton(
                onPressed: () {
                  if (_isChecked == true) {
                    storage.write(key: 'usingBiometric', value: 'true');
                    print('SI');
                  } else {
                    storage.write(key: 'usingBiometric', value: 'false');
                    print('NO');
                  }
                  Navigator.pushNamed(context, '/restaurantelogin');
                },
                icon: const Icon(Icons.app_registration_outlined))
          ],
        ),
      ),
    );
  }
}
