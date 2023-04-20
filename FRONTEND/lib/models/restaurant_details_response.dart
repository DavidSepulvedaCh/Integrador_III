import 'dart:convert';

RestaurantDetailsResponse restaurantDetailsResponse(String str){
  return RestaurantDetailsResponse.fromJson(jsonDecode(str));
}

class RestaurantDetailsResponse {
    String? latitude;
    String? longitude;
    String? adress;

    RestaurantDetailsResponse({this.latitude, this.longitude, this.adress});

    RestaurantDetailsResponse.fromJson(Map<String, dynamic> json) {
        latitude = json['latitude'];
        longitude = json['longitude'];
        adress = json['adress'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['latitude'] = latitude;
        data['longitude'] = longitude;
        data['adress'] = adress;
        return data;
    }
}