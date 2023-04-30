// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class ListOffers extends StatelessWidget {
  List<Offer> offers;

  ListOffers({super.key, required this.offers});

  static const titulo = Color.fromARGB(255, 13, 14, 13);
  static const descripcion = Color.fromARGB(255, 34, 34, 34);
  static const restaurante = Color.fromARGB(218, 65, 65, 65);
  static const precio = Color.fromARGB(255, 197, 101, 10);
  static const ubicacion = Color.fromARGB(255, 185, 109, 10);
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puede abrir la URL: $url';
    }
  }

  void _showModalImage(BuildContext context, String imageUrl) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SizedBox(
            height: 500,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => const SpinKitRing(
                      color: Colors.deepOrange,
                      size: 50.0,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showModal(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (context) {
        return SizedBox(
          height: 500,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {_showModalImage(context, offers[index].photo!);},
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: offers[index].photo!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height:
                            MediaQuery.of(context).size.width * 0.75, // NUEVO
                        placeholder: (context, url) => const SpinKitRing(
                          color: Colors.deepOrange,
                          size: 50.0,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
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
                          width: 350,
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
                          Stack(
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
                          )
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
                          Flexible(
                            // NUEVO
                            child: Text(
                              '\$${offers[index].price!}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 235, 79, 32),
                              ),
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
                            onPressed: () async {
                              lati = double.parse(offers[index].latitude!);
                              long = double.parse(offers[index].longitude!);
                              final destino = LatLng(lati, long);
                              //final origen = await _getCurrentLocation();
                              final origen = LatLng(7.098191, -73.123305);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapaRutaWidget(
                                      origen: origen, destino: destino),
                                ),
                              );
                              //openMaps(destino);
                            },
                            icon: const Icon(Icons.location_city),
                            label: const Text("¿Cómo llegar?"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.7,
                                  50), // NUEVO
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: offers.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showModal(context, index);
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: offers[index].photo!,
                                    width: 150,
                                    height: 150,
                                    placeholder: (context, url) =>
                                        const SpinKitRing(
                                      color: Colors.deepOrange,
                                      size: 50.0,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        offers[index].name!,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: titulo,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        offers[index].description!,
                                        style: const TextStyle(
                                          color: descripcion,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.justify,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        offers[index].restaurantName ??
                                            "Restaurante",
                                        style: const TextStyle(
                                          color: restaurante,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "\$ ${offers[index].price}",
                                        style: const TextStyle(
                                          color: precio,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      ButtonFavorite(idOffer: offers[index].id)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
