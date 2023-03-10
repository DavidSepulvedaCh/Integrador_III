import 'package:integrador/routes/imports.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool terminos = false;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordOneTextController = TextEditingController();
  TextEditingController passwordTwoTextController = TextEditingController();

  void register() async{
    if(!Functions.validateRegister(context, nameTextController.text, emailTextController.text, passwordOneTextController.text, passwordTwoTextController.text, terminos)){
      return;
    }
    RegisterRequestModel model = RegisterRequestModel(name: nameTextController.text, email: emailTextController.text, password: passwordOneTextController.text);
    final response = await APIService.register(model);
    if (response == 0) {
      // ignore: use_build_context_synchronously
      await Functions.loginSuccess(context);
    } else if (response == 1) {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(context, 'Error', 'Email ya registrado');
    } else {
      // ignore: use_build_context_synchronously
      CustomShowDialog.make(context, 'Error', 'Ocurrió un error. Intente más tarde');
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
                    image: AssetImage('assets/fondo2.jpg'),
                    fit: BoxFit.cover
                  ),
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
                      CustomTextField(textEditingController: nameTextController, hintText: 'Nombre completo', icon: Icons.person),
                      const SizedBox(height: 30),
                      CustomTextField(textEditingController: emailTextController, hintText: 'Dirección de correo', icon: Icons.email),
                      const SizedBox(height: 30),
                      PasswordField(textEditingController: passwordOneTextController, hintText: 'Contraseña'),
                      const SizedBox(height: 30),
                      PasswordField(textEditingController: passwordTwoTextController, hintText: 'Repite la contraseña'),
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
