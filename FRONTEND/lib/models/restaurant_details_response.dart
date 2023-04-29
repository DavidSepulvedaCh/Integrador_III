import 'dart:convert';

RestaurantDetailsResponse restaurantDetailsResponse(String str) {
  return RestaurantDetailsResponse.fromJson(jsonDecode(str));
}

class RestaurantDetailsResponse {
  String? description;
  String? latitude;
  String? longitude;
  String? address;
  String? city;

  RestaurantDetailsResponse({this.latitude, this.longitude, this.address});

  RestaurantDetailsResponse.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['adress'] = address;
    data['city'] = city;
    return data;
  }
}
