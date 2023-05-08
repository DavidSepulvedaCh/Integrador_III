import 'package:integrador/routes/imports.dart';
import 'dart:async';

class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;
  final Function(bool) setDoingFetch;
  final Function()? update;

  const RestaurantHeader(
      {Key? key, required this.restaurant, required this.setDoingFetch, this.update})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(restaurant.photo!),
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
                Colors.black.withOpacity(0.5),
                const Color.fromARGB(185, 0, 0, 0),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 5,
                right: 5,
                child: ButtonFavorite(
                  idRestaurant: restaurant.id,
                  setDoingFetch: setDoingFetch,
                  update: update,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.justify,
                      maxLines: 2,
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
                              const Icon(Icons.location_on,
                                  color: Colors.white),
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
                shadowColor: const Color.fromARGB(255, 190, 190, 190),
                elevation: 1.8,
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
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 124, 35, 8),
                                fontWeight: FontWeight.w400),
                            '\$ ${offer.price!}',
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
  final Restaurant restaurant;
  final Function()? update;

  const RestaurantSelected(
      {super.key, required this.restaurant, this.update});

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
    return Stack(
      children: [
        IgnorePointer(
          ignoring: _isDoingFetch,
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 228, 228, 228),
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
                          restaurant: widget.restaurant, setDoingFetch: _makeFetch, update: widget.update),
                      OffertsCard(
                        restaurantId: widget.restaurant.id!,
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
