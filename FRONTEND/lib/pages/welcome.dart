import 'package:flutter/material.dart';
import 'package:integrador/services/shared_service.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String name = SharedService.prefs.getString('name') ?? 'default';
  String texto = "WELCOME";

  @override
  Widget build(BuildContext context) {
    if (name != 'default') {
      texto += ' $name';
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('V I S T A  #2'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              //Función para logout
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              texto,
              style: const TextStyle(fontSize: 32),
            )
          ],
        ),
      ),
    );
  }
}
