import 'package:integrador/routes/imports.dart';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';


class Functions {
  static void logout(BuildContext context) async {
    await updateFavorites();
    await SQLiteDB.deleteFavorites();
    SharedService.prefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/login');
  }

  static Future<void> updateFavorites() async {
    List<String> favoritesListIds = await SQLiteDB.getFavoritesListIds();
    await APIService.updateFavorites(favoritesListIds);
  }

  static loginSuccess(BuildContext context) async {
    List<Restaurant> favorites = await APIService.getFavorites();
    await SQLiteDB.saveFavorites(favorites);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/index');
  }

  static bool validateRegister(BuildContext context, String name, String email,
      String password, String password2, bool terminos) {
    if (name == '') {
      CustomShowDialog.make(context, 'Error', 'Debes llenar todos los campos');
      return false;
    }
    if (password != password2) {
      CustomShowDialog.make(context, 'Error', 'Las contraseñas no coinciden');
      return false;
    }
    if (password.length < 8) {
      CustomShowDialog.make(
          context, 'Error', 'La contraseña debe tener mínimo 8 caracteres');
      return false;
    }
    if (!terminos) {
      CustomShowDialog.make(
          context, 'Error', 'Debes aceptar los términos y condiciones');
      return false;
    }
    if (!validate(context, email, password)) {
      return false;
    }
    return true;
  }

  static bool validate(BuildContext context, String email, String password) {
    RegExp emailValidator = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (email == '' || password == '') {
      customShowDialog(context, 'Error', 'Debes llenar todos los campos');
      return false;
    }
    if (!emailValidator.hasMatch(email)) {
      customShowDialog(context, 'Error', 'Email inválido');
      return false;
    }
    return true;
  }

  static Future<dynamic> customShowDialog(
      BuildContext context, String title, String content) {
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

  static Future<String?> uploadImageToCloudinary(File imageFile) async {
    final cloudinary = CloudinaryPublic('dti2zyzir', 'prueba');
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path),
      );

      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }


}
