import 'package:integrador/routes/imports.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class SQLiteDB {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'Restaurants.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE restaurants (id TEXT PRIMARY KEY, photo TEXT, address TEXT, latitude TEXT, longitude TEXT, name TEXT, description TEXT, city TEXT)",
      );
    }, version: 1);
  }

  static Future<void> saveFavorites(List<Restaurant> restaurants) async {
    final db = await _openDB();

    final batch = db.batch();

    for (final restaurant in restaurants) {
      batch.insert(
        'restaurants',
        restaurant.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  static Future<bool> existsFavorite(String id) async {
    Database database = await _openDB();

    final result = await database.query('restaurants',
        where: "id = ?", whereArgs: [id], limit: 1);

    return result.isNotEmpty;
  }

  static Future<void> insert(Restaurant restaurant) async {
    Database database = await _openDB();

    database.insert('restaurants', restaurant.toJson());
  }

  static Future<void> delete(String id) async {
    Database database = await _openDB();

    database.delete('restaurants', where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Restaurant>> getFavorites() async {
    Database database = await _openDB();
    String idUser = SharedService.prefs.getString('id') ?? 'default';
    if (idUser == 'default') {
      return [];
    }
    final List<Map<String, dynamic>> restaurant =
        await database.query('restaurants');

    return List.generate(
        restaurant.length,
        (index) => Restaurant(
            id: restaurant[index]['id'],
            address: restaurant[index]['address'],
            latitude: restaurant[index]['latitude'],
            longitude: restaurant[index]['longitude'],
            name: restaurant[index]['name'],
            description: restaurant[index]['description'],
            photo: restaurant[index]['photo'],
            city: restaurant[index]['city']));
  }

  static Future<List<String>> getFavoritesListIds() async {
    Database database = await _openDB();
    String idUser = SharedService.prefs.getString('id') ?? 'default';
    if (idUser == 'default') {
      return [];
    }
    final List<Map<String, dynamic>> restaurants = await database.query('restaurants');

    return List.generate(
      restaurants.length,
      (index) => restaurants[index]['id'],
    );
  }

  static Future<void> deleteFavorites() async {
    Database database = await _openDB();
    await database.execute("DELETE FROM restaurants");
  }
}
