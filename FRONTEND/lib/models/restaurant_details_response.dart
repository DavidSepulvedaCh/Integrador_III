import 'dart:convert';

RestaurantDetailsResponse restaurantDetailsResponse(String str){
  return RestaurantDetailsResponse.fromJson(jsonDecode(str));
}

class RestaurantDetailsResponse {
    String? latitude;
    String? longitude;
    String? address;

    RestaurantDetailsResponse({this.latitude, this.longitude, this.address});

    RestaurantDetailsResponse.fromJson(Map<String, dynamic> json) {
        latitude = json['latitude'];
        longitude = json['longitude'];
        address = json['address'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['latitude'] = latitude;
        data['longitude'] = longitude;
        data['adress'] = address;
        return data;
    }
}