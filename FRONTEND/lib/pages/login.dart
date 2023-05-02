// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:integrador/routes/imports.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isUsingBiometric = false;
  bool _isDoingFetch = false;

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    buildBiometrics();
  }

  buildBiometrics() async {
    final response = await SecureStorageService.isUsingBiometric();
    setState(() {
      _isUsingBiometric = response;
    });
  }

  void submit() async {
    if (Functions.validate(
        context, emailTextController.text, passwordTextController.text)) {
      LoginRequestModel model = LoginRequestModel(
          email: emailTextController.text,
          password: passwordTextController.text);
      final response = await APIService.login(model);
      if (response == 0) {
        Functions.loginSuccess(context);
      } else if (response == 10) {
        Navigator.pushReplacementNamed(context, '/restaurantIndex');
      } else if (response == 1) {
        CustomShowDialog.make(
            context, 'Error', 'Usuario o contraseña incorrecta');
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
  }

  void authenticate() async {
    final auth = await LocalAuth.authenticate();
    if (auth) {
      setState(() {
        _isDoingFetch = true;
      });
      await APIService.biometricLogin().then((value) => {
            if (value == 0)
              {Functions.loginSuccess(context)}
            else if (value == 10)
              {Navigator.pushReplacementNamed(context, '/restaurantIndex')}
            else if (value == 1)
              {
                CustomShowDialog.make(
                    context, 'Error', 'Usuario o contraseña incorrecta'),
                setState(() {
                  _isDoingFetch = false;
                })
              }
            else
              {
                CustomShowDialog.make(
                    context, 'Error', 'Ocurrió un error. Intente más tarde'),
                setState(() {
                  _isDoingFetch = false;
                })
              }
          });
    }
  }

  Widget buildBiometricWidget() {
    Widget returnWidget = Container();
    if (_isUsingBiometric) {
      returnWidget = GestureDetector(
        onTap: () => authenticate(),
        child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blueGrey, width: 2.0),
                borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.fingerprint,
                color: Color.fromARGB(220, 255, 86, 34),
                size: 50,)),
      );
    }
    return returnWidget;
  }

  Widget buildBtnSingUp() {
    return GestureDetector(
        onTap: () {},
        child: const Text(
          "¿No tienes una cuenta? Registrate!",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

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
        const Flexible(
          flex: 1,
          child: SizedBox(
            width: 100,
          ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
              children: <Widget>[
                IgnorePointer(
                  ignoring: _isDoingFetch,
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/fondo.jpg'),
                          fit: BoxFit.cover),
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
                          buildBiometricWidget(),
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
      },
    );
  }
}
