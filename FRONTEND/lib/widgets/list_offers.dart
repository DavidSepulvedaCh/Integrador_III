import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class ListOffers extends StatefulWidget {
  List<Offer> offers;

  ListOffers({super.key, required this.offers});

  @override
  State<ListOffers> createState() => _ListOffersState();
}

class _ListOffersState extends State<ListOffers> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: widget.offers.length,
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
                            Image.network(widget.offers[index].photo!,
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
                                widget.offers[index].name!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Raleway'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.offers[index].description!,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Raleway'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "\$ ${widget.offers[index].price}",
                                style: const TextStyle(fontFamily: 'Raleway'),
                              ),
                              const SizedBox(height: 8),
                              ButtonFavorite(idOffer: widget.offers[index].id)
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
    );
  }
}
