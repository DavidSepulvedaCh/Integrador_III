import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class GridOffers extends StatefulWidget {
  List<Offer> offers;

  GridOffers({super.key, required this.offers});

  @override
  State<GridOffers> createState() => _GridOffersState();
}

class _GridOffersState extends State<GridOffers> {

  Widget gridElement(BuildContext context, int index) {
    return Card(
        margin: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            Image.network(widget.offers[index].photo!,
                height: 90, fit: BoxFit.cover),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.offers[index].name!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.offers[index].description!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Raleway',
                        fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$ ${widget.offers[index].price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                      ),
                      ButtonFavorite(idOffer: widget.offers[index].id)
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }


  @override
  Widget build(BuildContext context) {
    return GridView.count(
        childAspectRatio: 0.8,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        crossAxisCount: 2,
        children: List.generate(widget.offers.length, (index) {
          return gridElement(context, index);
        }),
      );
  }
}
