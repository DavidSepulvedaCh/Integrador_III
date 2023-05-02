class Restaurant {
  String? id;
  String? photo;
  String? address;
  String? latitude;
  String? longitude;
  String? name;
  String? description;
  String? city;

  Restaurant({
    this.id,
    this.photo,
    this.address,
    this.latitude,
    this.longitude,
    this.name,
    this.description,
    this.city,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json["idUser"]["_id"].toString();
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json["idUser"]["name"];
    photo = json["idUser"]["photo"];
    description = json["description"];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'photo': photo,
      'description': description,
      'city': city,
    };
  }
}