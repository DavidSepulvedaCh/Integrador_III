// ignore_for_file: sort_child_properties_last, deprecated_member_use

import 'package:integrador/routes/imports.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isDoingFetch = false;
  bool terminos = false;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordOneTextController = TextEditingController();
  TextEditingController passwordTwoTextController = TextEditingController();

  void term() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Términos y condiciones'),
          content:
              const Text('Al acceder, aceptas los términos y condiciones.'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                primary: Colors.deepOrange, // Color de fondo del botón
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                primary: Colors.deepOrange, // Color de fondo del botón
              ),
              child: const Text('Aceptar'),
              onPressed: () {
                register();
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value) {
        // El usuario ha aceptado los términos y condiciones, continuar con la lógica de la aplicación aquí
      } else {
        // El usuario ha cancelado la acción, realizar alguna acción aquí si es necesario
      }
    });
  }

  void register() async {
    setState(() {
      _isDoingFetch = true;
    });
    if (!Functions.validateRegister(
        context,
        nameTextController.text,
        emailTextController.text,
        passwordOneTextController.text,
        passwordTwoTextController.text,
        terminos)) {
      setState(() {
        _isDoingFetch = false;
      });
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
      setState(() {
        _isDoingFetch = false;
      });
    } else if (response == 2) {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(context, 'Error', 'No se pudo registrar el email');
      setState(() {
        _isDoingFetch = false;
      });
    } else {
      // ignore: use_build_context_synchronously
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
          GestureDetector(
            onTap: (() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Terminos()));
            }),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Acepto ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text: 'Términos y condiciones',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            IgnorePointer(
              ignoring: _isDoingFetch,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/fondo2.jpg'),
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
                        'Registro de usuario',
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
                          labelText: 'Nombre completo',
                          hintText: 'Nombre completo',
                          icon: Icons.person),
                      const SizedBox(height: 30),
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
                      ButtonOne(onClick: term, text: 'Registrar'),
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
    );
  }
}
