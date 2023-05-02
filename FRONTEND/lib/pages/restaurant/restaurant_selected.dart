import 'package:integrador/routes/imports.dart';
import 'package:http/http.dart' as http;
import 'package:integrador/config.dart';
import 'dart:async';

class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantHeader({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              // ignore: unnecessary_string_interpolations
              image: NetworkImage('${restaurant.photo!}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                const Color.fromARGB(131, 0, 0, 0),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  restaurant.name!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                  restaurant.description!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify,
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on, color: Colors.white),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              restaurant.address!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OffertsCard extends StatefulWidget {
  final String restaurantId;

  OffertsCard({required this.restaurantId});

  @override
  _OffertsCardState createState() => _OffertsCardState();
}

class _OffertsCardState extends State<OffertsCard> {
  List<Offer> _offers = [];
  

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    List<Offer> offers = await getOffertsRest(widget.restaurantId);
    setState(() {
      _offers = offers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Ofertas'),
      ),
      body: ListView.builder(
        itemCount: _offers.length,
        itemBuilder: (BuildContext context, int index) {
          Offer offer = _offers[index];
          return Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(offer.photo!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.name!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        offer.description!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RestaurantSelected extends StatelessWidget {
  final List<Restaurant> restaurants;
  final String restaurantId;

  const RestaurantSelected(
      {super.key, required this.restaurants, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final List<Restaurant> restaurants =
        ModalRoute.of(context)!.settings.arguments as List<Restaurant>;
    final Restaurant restaurant =
        restaurants.firstWhere((r) => r.id == restaurantId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            title: Text("FOODHUB"),
            backgroundColor: Color.fromARGB(197, 221, 91, 15),
            floating: true,
            snap: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                RestaurantHeader(restaurant: restaurants[0]),
                OffertsCard(
                  restaurantId: restaurant.id!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
