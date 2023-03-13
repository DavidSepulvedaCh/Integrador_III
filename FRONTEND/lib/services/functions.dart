import 'package:integrador/routes/imports.dart';

class Functions {
  static void logout(BuildContext context) async {
    await updateFavorites();
    await SQLiteDB.deleteFavorites();
    SharedService.prefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/login');
  }

  static Future<void> updateFavorites() async {
    List<String> favoritesListIds = await SQLiteDB.getFavoritesListIds();
    await APIService.updateFavorites(favoritesListIds);
  }

  static loginSuccess(BuildContext context) async {
    List<Offer> favorites = await APIService.getFavorites();
    await SQLiteDB.saveFavorites(favorites);
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/index');
  }

  static bool validate(BuildContext context, String email, String password) {
    RegExp emailValidator = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (email == '' || password == '') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Debes llenar todos los campos'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Ok')),
                ],
              ));
      return false;
    }
    if (!emailValidator.hasMatch(email)) {
      customShowDialog(context, 'Error', 'Email inválido');
      return false;
    }
    return true;
  }

  static Future<dynamic> customShowDialog(BuildContext context, String title, String content){
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Ok')),
                ],
              ));
  }
}
