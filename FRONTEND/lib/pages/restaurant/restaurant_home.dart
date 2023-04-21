import 'package:integrador/routes/imports.dart';

class HomeRestaurante extends StatefulWidget {
  const HomeRestaurante({Key? key}) : super(key: key);

  @override
  _HomeRestauranteState createState() => _HomeRestauranteState();
}

class _HomeRestauranteState extends State<HomeRestaurante> {
  
  final _scrollController = ScrollController();

  bool _isAppBarHidden = false;
  String _restaurantName = "";
  String _restaurantAddress = "";
  List<Offer> offerss = <Offer>[];
  late Widget view = Container();

  @override
  void initState() {
    super.initState();
    getRestaurantDetails();
    setOffers();
    _scrollController.addListener(() {
      final isAppBarHidden = _scrollController.offset > 0;
      if (isAppBarHidden != _isAppBarHidden) {
        setState(() {
          _isAppBarHidden = isAppBarHidden;
        });
      }
    });
  }

  Future<void> setOffers() async {
    offerss.clear();
    await getOffers().then((value) {
      setState(() {
        offerss.addAll(value);
        view = ListOffers(offers: offerss);
      });
    });
  }

  Future<List<Offer>> getOffers() async {
    var register = await APIService.getOffersByIdUser();
    return register;
  }

  Future<void> getRestaurantDetails() async {
    await APIService.getRestaurantDetails();
    setState(() {
      _restaurantName = SharedService.prefs.getString('name') ?? "Restaurante";
      _restaurantAddress = SharedService.prefs.getString('address') ?? "Colombia";
    });
  }

  Future<void> removeOffer(String idOffer) async {
    bool response = await APIService.removeOffer(idOffer);
    if(response){
      setOffers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isAppBarHidden ? 0 : 95,
              child: AppBar(
                backgroundColor: Colors.deepOrange,
                title: const Text(
                  'Restaurante',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                leading: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    SharedService.prefs.clear();
                    Navigator.pushNamed(context, '/login');
                  },
                  icon: const Icon(Icons.logout),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isAppBarHidden ? 80 : 0,
            child: Row(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'FOODHUB',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.network(
                        'https://bit.ly/3mTInGh',
                        height: 35,
                        width: 35,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 190,
                            child: Text(
                              _restaurantName,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            _restaurantAddress,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: offerss.length,
              itemBuilder: (BuildContext context, int index) {
                return OfertaRestaurante(removeOffer: removeOffer, id: offerss[index].id!, description: offerss[index].description!, photo: offerss[index].photo!, price: offerss[index].price!, restaurantName: _restaurantName, title: offerss[index].name!);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/nuevapromocion');
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
