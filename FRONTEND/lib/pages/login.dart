import 'package:integrador/routes/imports.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
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

    /* ===============WIDGET'S===================== */
    Widget buildBtnSingUp() {
      return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Register()));
        },
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "¿No tienes una cuenta?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w100),
              ),
              TextSpan(
                text: " Registrate!",
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
                      ButtonOne(onClick: submit, text: 'Ingresar'),
                      buildBtnSingUp(),
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