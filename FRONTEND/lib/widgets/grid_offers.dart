import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class GridOffers extends StatelessWidget {
  List<Offer> offers;

  Position? currentLocation;
  double lati = 0.0000;
  double long = 0.0000;

  Future<LatLng> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  String generateMapsUrl(LatLng origin, LatLng destination) {
    final url = 'https://www.google.com/maps/dir/?api=1&'
        'origin=${origin.latitude},${origin.longitude}&'
        'destination=${destination.latitude},${destination.longitude}';
    return url;
  }

  void openMaps(LatLng destination) async {
    final origin = await _getCurrentLocation();
    final url = generateMapsUrl(origin, destination);
    if (await canLaunchUrl(Uri.http(url))) {
      await launchUrl(Uri.http(url));
    } else {
      throw 'No se puede abrir la URL: $url';
    }
  }

  void _showModal(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          child: Column(
            children: <Widget>[
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      offers[index].photo!,
                    ),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Text(
                        offers[index].restaurantName ?? "Nombre restaurante",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Positioned(
                      top: 48,
                      left: 16,
                      child: SizedBox(
                        width: 350, // ajusta el ancho a tu necesidad
                        child: Text(
                          offers[index].address!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Positioned(
                            child: SizedBox(
                              width: 280,
                              child: Text(
                                offers[index].name!,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        offers[index].description!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Precio: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${offers[index].price!}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 235, 79, 32),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              lati = double.parse(offers[index].latitude!);
                              long = double.parse(offers[index].longitude!);
                              final destino = LatLng(lati, long);
                              openMaps(destino);
                            },
                            icon: const Icon(Icons.location_city),
                            label: const Text("¿Como llegar?"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  GridOffers({super.key, required this.offers});

  Widget gridElement(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showModal(context, index);
      },
      child: Card(
        margin: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            Image.network(offers[index].photo!, height: 90, fit: BoxFit.cover),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  offers[index].name!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    offers[index].description!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Raleway',
                        fontSize: 12),
                    maxLines: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$ ${offers[index].price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                      ),
                      ButtonFavorite(idOffer: offers[index].id)
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.8,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      crossAxisCount: 2,
      children: List.generate(offers.length, (index) {
        return gridElement(context, index);
      }),
    );
  }
}
