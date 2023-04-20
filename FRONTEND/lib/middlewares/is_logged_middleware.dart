import 'package:integrador/routes/imports.dart';

class IsLoggedMiddleware extends StatefulWidget {
  const IsLoggedMiddleware({super.key});

  @override
  State<IsLoggedMiddleware> createState() => _IsLoggedMiddlewareState();
}

class _IsLoggedMiddlewareState extends State<IsLoggedMiddleware> {
  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  isLoggedIn() async {
    await SharedService.isLoggedIn().then((value) => {
      if(value == 0){
        Functions.loginSuccess(context)
      } else if (value == 1){
        Navigator.pushReplacementNamed(context, '/restaurantIndex')
      } else {
        Navigator.pushReplacementNamed(context, '/login')
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
