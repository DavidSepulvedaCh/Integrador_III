import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class ListOffers extends StatelessWidget {
  List<Offer> offers;

  ListOffers({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        // ignore: prefer_const_constructors
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text('¡Para mayor facilidad seleccione los filtros de tu preferencia!'),
              const SizedBox(height: 5),
              const ZonaBottomSheet(),
            ],
          )
        ),
        Expanded(
          child: ListView.builder(
            itemCount: offers.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Image.network(offers[index].photo!,
                                    height: 120, width: 150, fit: BoxFit.cover),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    offers[index].name!,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Raleway'),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    offers[index].description!,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Raleway'),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "\$ ${offers[index].price}",
                                    style:
                                        const TextStyle(fontFamily: 'Raleway'),
                                  ),
                                  const SizedBox(height: 8),
                                  ButtonFavorite(idOffer: offers[index].id)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    ));
  }
}
