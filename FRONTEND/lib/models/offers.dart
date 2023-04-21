class Offer{
  String? id;
  String? address;
  String? latitude;
  String? longitude;
  String? name;
  String? description;
  String? photo;
  double? price;
  String? idSeller;
  String? city;

  Offer({
    this.id,
    this.address,
    this.latitude,
    this.longitude,
    this.name,
    this.description,
    this.photo,
    this.price,
    this.idSeller,
    this.city
  });

  Offer.fromJson(Map<String, dynamic> json){
    id = json["_id"];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json["name"];
    description = json["description"];
    photo = json["photo"];
    price = json["price"].toDouble();
    idSeller = json['idSeller'];
    city = json['city'];
  }

  Map<String, dynamic> toJson(){
    return { 'id': id, 'address': address, 'latitude': latitude, 'longitude': longitude, 'name': name, 'description': description, 'photo': photo, 'price': price,
    'idSeller': idSeller };
  }
}