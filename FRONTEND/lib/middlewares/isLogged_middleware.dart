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
    var session = await SharedService.isLoggedIn();
    if (session) {
      // ignore: use_build_context_synchronously
      Functions.loginSuccess(context);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
