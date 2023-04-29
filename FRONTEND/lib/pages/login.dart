import 'package:integrador/routes/imports.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  bool _isDoingFetch = false;

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  /* ==================Functions================= */
  void submit() async {
    if (Functions.validate(
        context, emailTextController.text, passwordTextController.text)) {
      LoginRequestModel model = LoginRequestModel(
          email: emailTextController.text,
          password: passwordTextController.text);
      final response = await APIService.login(model);
      if (response == 0) {
        // ignore: use_build_context_synchronously
        Functions.loginSuccess(context);
      } else if (response == 10) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/restaurantIndex');
      } else if (response == 1) {
        // ignore: use_build_context_synchronously
        CustomShowDialog.make(
            context, 'Error', 'Usuario o contraseña incorrecta');
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
  }

  /* ===============WIDGET'S===================== */
  Widget buildBtnSingUp() {
    return GestureDetector(
        onTap: () {},
        child: const Text(
          "¿No tienes una cuenta? Registrate!",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  /* ===============WIDGET'S===================== */

  Widget btnsRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Register()));
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.deepOrange,
                  ),
                  Text('Persona',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          width: 100,
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterRestaurant()));
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.restaurant,
                    size: 40,
                    color: Colors.deepOrange,
                  ),
                  Text('Restaurante',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
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
                      image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 45,
                    vertical: 90,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Inicio de Sesión',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Open Sans'),
                      ),
                      const SizedBox(height: 48),
                      CustomTextField(
                          textEditingController: emailTextController,
                          labelText: 'Correo electrónico',
                          hintText: 'Dirección de correo',
                          icon: Icons.email),
                      const SizedBox(height: 48),
                      PasswordField(
                          textEditingController: passwordTextController,
                          labelText: 'Contraseña',
                          hintText: 'Contraseña'),
                      const SizedBox(height: 25),
                      const SizedBox(height: 25),
                      ButtonOne(
                          onClick: () {
                            setState(() {
                              _isDoingFetch = true;
                            });
                            submit();
                          },
                          text: "Ingresar"),
                      buildBtnSingUp(),
                      const SizedBox(height: 15),
                      btnsRegister()
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
