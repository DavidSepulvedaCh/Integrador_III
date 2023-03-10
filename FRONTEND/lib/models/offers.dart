class Offer{
  String? id;
  String? address;
  String? name;
  String? description;
  String? photo;
  double? price;
  String? idSeller;
  String? city;

  Offer({
    this.id,
    this.address,
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
    name = json["name"];
    description = json["description"];
    photo = json["photo"];
    price = json["price"].toDouble();
    idSeller = json['idSeller'];
    city = json['city'];
  }

  Map<String, dynamic> toJson(){
    return { 'id': id, 'address': address, 'name': name, 'description': description, 'photo': photo, 'price': price,
    'idSeller': idSeller };
  }
}