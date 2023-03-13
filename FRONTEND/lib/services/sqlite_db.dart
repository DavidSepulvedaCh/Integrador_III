import 'package:integrador/routes/imports.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class SQLiteDB {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'Offers.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE offers (id TEXT PRIMARY KEY, address TEXT, name TEXT, description TEXT, photo TEXT, price REAL, idSeller TEXT, city TEXT)",
      );
    }, version: 1);
  }

  static Future<void> saveFavorites(List<Offer> offers) async {
    final db = await _openDB();

    final batch = db.batch();

    for (final offer in offers) {
      batch.insert(
        'offers',
        offer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  static Future<bool> existsFavorite(String id) async {
    Database database = await _openDB();

    final result = await database.query('offers',
        where: "id = ?", whereArgs: [id], limit: 1);

    return result.isNotEmpty;
  }

  static Future<void> insert(Offer offer) async {
    Database database = await _openDB();

    database.insert('offers', offer.toJson());
  }

  static Future<void> delete(String id) async {
    Database database = await _openDB();

    database.delete('offers', where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Offer>> getFavorites() async {
    Database database = await _openDB();
    String idUser = SharedService.prefs.getString('id') ?? 'default';
    if (idUser == 'default') {
      return [];
    }
    final List<Map<String, dynamic>> offers =
        await database.query('offers');

    return List.generate(
        offers.length,
        (index) => Offer(
            id: offers[index]['id'],
            address: offers[index]['address'],
            name: offers[index]['name'],
            description: offers[index]['description'],
            photo: offers[index]['photo'],
            price: offers[index]['price'],
            idSeller: offers[index]['idSeller'],
            city: offers[index]['city']));
  }

  static Future<List<String>> getFavoritesListIds() async {
    Database database = await _openDB();
    String idUser = SharedService.prefs.getString('id') ?? 'default';
    if (idUser == 'default') {
      return [];
    }
    final List<Map<String, dynamic>> offers=
        await database.query('offers');

    return List.generate(
      offers.length,
      (index) => offers[index]['id'],
    );
  }

  static Future<void> deleteFavorites() async {
    Database database = await _openDB();
    await database.execute("DELETE FROM offers");
  }
}
