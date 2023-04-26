// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:integrador/config.dart';
import 'package:integrador/models/restaurant_details_response.dart';
import 'package:integrador/routes/imports.dart';

class APIService {
  static Future<int> register(RegisterRequestModel model) async {
    Uri url = Uri.http(Config.apiURL, Config.registerAPI);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    final dataBody = json.encode(model.toJson());
    try {
      final response = await http
          .post(url, headers: header, body: dataBody)
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        await SharedService.setLogginDetails(loginResponseModel(response.body));
        return 0;
      } else if (response.statusCode == 409) {
        return 1;
      } else {
        return 2;
      }
    } catch (e) {
      return 3;
    }
  }

  static Future<int> login(LoginRequestModel model) async {
    Uri url = Uri.http(Config.apiURL, Config.loginAPI);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    final dataBody = json.encode(model.toJson());
    try {
      final response = await http
          .post(url, headers: header, body: dataBody)
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        LoginResponseModel model = loginResponseModel(response.body);
        await SharedService.setLogginDetails(model);
        if (model.role == 'person') {
          return 0;
        } else if (model.role == 'restaurant') {
          return 10;
        }
        return 2;
      } else {
        return 1;
      }
    } catch (e) {
      return 2;
    }
  }

  static Future<int> isValidToken(String token) async {
    Uri url = Uri.http(Config.apiURL, Config.isValidTokenAPI);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    try {
      final response = await http
          .post(url, headers: header, body: jsonEncode({'token': token}))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var role = jsonResponse['role'].toString();
        return role == "person" ? 0 : 1;
      } else {
        return -1;
      }
    } catch (e) {
      return -1;
    }
  }

  static Future<List<Offer>> getOffers() async {
    Uri url = Uri.http(Config.apiURL, Config.getOffers);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    try {
      final response = await http
          .post(url, headers: header, body: jsonEncode({'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Offer> offerList =
            jsonList.map((json) => Offer.fromJson(json)).toList();
        return offerList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Offer>> getOffersByIdUser() async {
    Uri url = Uri.http(Config.apiURL, Config.getOffersByIdUser);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    var idUser = SharedService.prefs.getString("id");
    try {
      final response = await http
          .post(url, headers: header, body: jsonEncode({ 'idUser': idUser, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Offer> offerList =
            jsonList.map((json) => Offer.fromJson(json)).toList();
        return offerList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Offer>> getOffersByPriceRange(int minPrice, int maxPrice) async {
    Uri url = Uri.http(Config.apiURL, Config.getOfferByPriceRange);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    try {
      final response = await http
          .post(url,
              headers: header,
              body: jsonEncode({'minPrice': minPrice, 'maxPrice': maxPrice, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Offer> offerList =
            jsonList.map((json) => Offer.fromJson(json)).toList();
        return offerList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Offer>> getOffersByCity(String city) async {
    Uri url = Uri.http(Config.apiURL, Config.getOfferByCity);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    try {
      final response = await http
          .post(url,
              headers: header,
              body: jsonEncode({'city': city, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Offer> offerList =
            jsonList.map((json) => Offer.fromJson(json)).toList();
        return offerList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Offer>> getOffersByCityAndPriceRange(String city, int minPrice, int maxPrice) async {
    Uri url = Uri.http(Config.apiURL, Config.getOfferByCityAndPriceRange);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    try {
      final response = await http
          .post(url,
              headers: header,
              body: jsonEncode({'city': city, 'minPrice': minPrice, 'maxPrice': maxPrice, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Offer> offerList =
            jsonList.map((json) => Offer.fromJson(json)).toList();
        return offerList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<double> getMaxPriceAllOffers() async {
    Uri url = Uri.http(Config.apiURL, Config.getMaxPriceAllOffers);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    try {
      final response = await http
          .post(url, headers: header, body: jsonEncode({'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var maxPrice = double.parse(jsonResponse['maxPrice'].toString());
        return maxPrice;
      } else {
        return -1;
      }
    } catch (e) {
      return -1;
    }
  }

  static Future<Offer?> getOfferById(String idOffer) async {
    Uri url = Uri.http(Config.apiURL, Config.getOfferById);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    try {
      final response = await http
          .post(url,
              headers: header,
              body: jsonEncode({'id': idOffer, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var offer = jsonDecode(response.body);
        offer = offer['offer'];
        return Offer.fromJson(offer);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateFavorites(List<String> favoritesListIds) async {
    Uri url = Uri.http(Config.apiURL, Config.updateFavorite);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    var id = SharedService.prefs.getString('id');
    try {
      final response = await http
          .post(url,
              headers: header,
              body: jsonEncode(
                  {'ids': favoritesListIds, 'idUser': id, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<Offer>> getFavorites() async {
    Uri url = Uri.http(Config.apiURL, Config.getFavorites);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    var id = SharedService.prefs.getString('id');
    try {
      final response = await http
          .post(url,
              headers: header, body: jsonEncode({'idUser': id, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> offersJson = json['offers'];
        List<Offer> offerList =
            offersJson.map((offerJson) => Offer.fromJson(offerJson)).toList();
        return offerList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<bool> getRestaurantDetails() async {
    Uri url = Uri.http(Config.apiURL, Config.getRestaurantDetails);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    var id = SharedService.prefs.getString('id');
    try {
      final response = await http
          .post(url,
              headers: header, body: jsonEncode({'idUser': id, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        RestaurantDetailsResponse model = restaurantDetailsResponse(response.body);
        await SharedService.setRestaurantDetails(model);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeOffer(String idOffer) async {
    Uri url = Uri.http(Config.apiURL, Config.removeOffer);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    try {
      final response = await http
          .post(url,
              headers: header, body: jsonEncode({'id': idOffer, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> createOffer(String name, String description, String price, String imageUrl) async {
    Uri url = Uri.http(Config.apiURL, Config.createOffer);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    var token = SharedService.prefs.getString('token');
    var address = SharedService.prefs.getString('address');
    var latitude = SharedService.prefs.getString('latitude');
    var longitude = SharedService.prefs.getString('longitude');
    var city = SharedService.prefs.getString('city');
    try {
      if(token == null || address == null || latitude == null || longitude == null || city == null){
        return false;
      }
      final response = await http
          .post(url,
              headers: header, body: jsonEncode({'address': address, 'latitude': latitude, 'longitude': longitude, 
              'city': city, 'name': name, 'description': description, 'photo': imageUrl, 'price': price, 'token': token}))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<int> registerRestaurant(RegisterRequestModel model, String latitude, String longitude, String address, String city) async {
    Uri url = Uri.http(Config.apiURL, Config.registerRestaurant);
    final header = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    try {
      final response = await http
          .post(url, headers: header, body: jsonEncode({"email": model.email, "name": model.name, "password": model.password, 
          "latitude": latitude, "longitude": longitude, "address": address, "city": city}))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        await SharedService.setLogginDetails(loginResponseModel(response.body));
        return 0;
      } else if (response.statusCode == 409) {
        return 1;
      } else {
        return 2;
      }
    } catch (e) {
      return 3;
    }
  }
}
