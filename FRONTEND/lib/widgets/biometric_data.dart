import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class BiometricData extends StatefulWidget {
  const BiometricData({super.key});

  @override
  State<BiometricData> createState() => _BiometricDataState();
}

class _BiometricDataState extends State<BiometricData> {
  bool _usingBiometric = false;

  @override
  void initState() {
    isUsingBiometric();
    super.initState();
  }

  void isUsingBiometric() async {
    final biometric = await SecureStorageService.isUsingBiometric();
    setState(() {
      _usingBiometric = biometric;
    });
  }

  /* ================ Functions ============ */

  void authenticate(Function(BuildContext) next) async {
    final authenticate = await LocalAuth.authenticate();
    setState(() {
      if (authenticate) {
        next(context);
      }
    });
  }

  void showModalBiometricLogin(BuildContext mainContext) {
    TextEditingController emailTextController = TextEditingController();
    TextEditingController passwordTextController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const Text(
                      'Confirmar inicio de sesión con huella',
                      style: TextStyle(fontSize: 22),
                    )),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Email'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 13, bottom: 13),
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                      controller: passwordTextController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Password'),
                      obscureText: true),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(HexColor('#E64A19')),),
                    onPressed: () async {
                      Navigator.pop(context);
                      registerBiometric(emailTextController.text,
                          passwordTextController.text, mainContext);
                    },
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(fontSize: 22),
                    ))
              ],
            ),
          );
        });
      },
    );
  }

  void registerBiometric(
      String email, String password, BuildContext mainContext) async {
    await APIService.biometricRegister(email, password).then((value) => {
          if (value == 1)
            {
              setState(() {
                _usingBiometric = true;
              })
            }
          else if (value == 2)
            {
              CustomShowDialog.make(
                  mainContext, 'Error', 'Credenciales incorrectas')
            }
          else if (value == 3)
            {
              CustomShowDialog.make(mainContext, 'Error',
                  'Por el momento su cuenta no puede usar login biométrico')
            }
          else if (value == 4 || value == 5)
            {
              CustomShowDialog.make(
                  mainContext, 'Error', 'Ocurrió un error. Intente más tarde')
            }
        });
  }

  void disableBiometric(BuildContext context) async {
    await APIService.removeBiometric().then((value) => {
          if (value)
            {
              CustomShowDialog.make(context, 'Éxito',
                  'Se ha deshabilitado el incio de sesión con huella'),
              setState(() {
                _usingBiometric = false;
              })
            }
          else
            {
              CustomShowDialog.make(context, 'Error',
                  'No se ha podido deshabilitar el incio de sesión con huella')
            }
        });
  }

  /* =============================================================== */

  Widget buildBiometrics() {
    if (_usingBiometric) {
      return Center(
          child: Column(
        children: [
          const Text(
            'Inicio de sesión con huella habilitado',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32),
          ),
          Container(
            height: 50,
            width: 240,
            margin: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                onPressed: () =>
                    authenticate((context) => disableBiometric(context)),
                child: const Text(
                  'Deshabilitar',
                  style: TextStyle(fontSize: 22),
                )),
          )
        ],
      ));
    } else {
      return Center(
        child: Column(
          children: [
            const Text(
              'Habilitar login con datos biométricos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32),
            ),
            Container(
              height: 50,
              width: 240,
              margin: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(HexColor('#E64A19')),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  onPressed: () => authenticate(
                      (context) => showModalBiometricLogin(context)),
                  child: const Text(
                    'Habilitar',
                    style: TextStyle(fontSize: 22),
                  )),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBiometrics();
  }
}
