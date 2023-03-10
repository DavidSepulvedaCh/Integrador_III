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
}
