import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:integrador/config.dart';
import 'package:integrador/models/login_response_model.dart';
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
      } else {
        return 1;
      }
    } catch (e) {
      return 2;
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
        await SharedService.setLogginDetails(loginResponseModel(response.body));
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      return 2;
    }
  }

  static Future<bool> isValidToken(String token) async {
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
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
}
