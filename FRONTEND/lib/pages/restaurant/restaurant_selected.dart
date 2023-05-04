import 'package:integrador/routes/imports.dart';
import 'dart:async';

class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;
  final Function(bool) setDoingFetch;

  const RestaurantHeader(
      {super.key, required this.restaurant, required this.setDoingFetch});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              // ignore: unnecessary_string_interpolations
              image: CachedNetworkImageProvider('${restaurant.photo!}'),
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
                          Flexible(
                              child: ButtonFavorite(
                            idRestaurant: restaurant.id,
                            setDoingFetch: setDoingFetch,
                          )),
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

  const OffertsCard({super.key, required this.restaurantId});

  @override
  State<OffertsCard> createState() => _OffertsCardState();
}

class _OffertsCardState extends State<OffertsCard> {
  final List<Offer> _offers = <Offer>[];

  @override
  void initState() {
    super.initState();
    setOffers();
  }

  Future<void> setOffers() async {
    _offers.clear();
    await _loadOffers().then((value) {
      setState(() {
        _offers.addAll(value);
      });
    });
  }

  Future<List<Offer>> _loadOffers() async {
    var offers = await APIService.getOffersByIdUser(widget.restaurantId);
    return offers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Offer>>(
      future: _loadOffers(),
      builder: (BuildContext context, AsyncSnapshot<List<Offer>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Offer offer = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(offer.photo!),
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
                          Text(
                            style: const TextStyle(fontSize: 16),
                            '\$${offer.price!}',
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

class RestaurantSelected extends StatefulWidget {
  final List<Restaurant> restaurants;
  final String restaurantId;

  const RestaurantSelected(
      {super.key, required this.restaurants, required this.restaurantId});

  @override
  State<RestaurantSelected> createState() => _RestaurantSelectedState();
}

class _RestaurantSelectedState extends State<RestaurantSelected> {
  bool _isDoingFetch = false;

  void _makeFetch(bool value) {
    setState(() {
      _isDoingFetch = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Restaurant restaurant =
        widget.restaurants.firstWhere((r) => r.id == widget.restaurantId);
    return Stack(
      children: [
        IgnorePointer(
          ignoring: _isDoingFetch,
          child: Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                const SliverAppBar(
                  title: Text("FOODHUB"),
                  backgroundColor: Colors.deepOrange,
                  floating: true,
                  snap: true,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      RestaurantHeader(
                          restaurant: restaurant, setDoingFetch: _makeFetch),
                      OffertsCard(
                        restaurantId: restaurant.id!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isDoingFetch)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
