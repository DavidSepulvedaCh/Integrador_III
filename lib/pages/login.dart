import 'package:integrador/routes/imports.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isRememberMe = false;
  Widget buildRememberPass() {
    return Container(
      height: 20,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: isRememberMe,
              checkColor: Colors.grey,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  isRememberMe = value!;
                });
              },
            ),
          ),
          const Text(
            'Mantener inciada la sesión',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget buildBtnSingUp() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Register()));
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
                    image: AssetImage('fondo.jpg'),
                    fit: BoxFit.cover
                  ),
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
                      buildEmail(),
                      const SizedBox(height: 48),
                      buildPassword(),
                      const SizedBox(height: 25),
                      buildRememberPass(),
                      const SizedBox(height: 25),
                      buildBtnLogin(),
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
