import 'dart:async';

import 'package:integrador/routes/imports.dart';
import 'package:integrador/widgets/new_promo.dart';

import '../edit_user.dart';

class HomeRestaurante extends StatefulWidget {
  const HomeRestaurante({Key? key}) : super(key: key);

  @override
  State<HomeRestaurante> createState() => _HomeRestauranteState();
}

class _HomeRestauranteState extends State<HomeRestaurante> {
  final _scrollController = ScrollController();

  bool reload = false;
  bool _isAppBarHidden = false;
  bool _isVisible = false;
  Timer? _timer;
  String _restaurantName = "";
  String _restaurantAddress = "";
  String _restaurantEmail = "";
  String _restaurantPhoto = "";
  String _restaurantDescription = "";
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
        if (_isAppBarHidden) {
          _timer = Timer(const Duration(milliseconds: 280), () {
            if (_isAppBarHidden) {
              setState(() {
                _isVisible = true;
              });
            }
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isVisible = false;
          });
        }
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
      _restaurantEmail = SharedService.prefs.getString("email") ?? "email";
      _restaurantAddress =
          SharedService.prefs.getString('address') ?? "Colombia";
      _restaurantPhoto = SharedService.prefs.getString('photo') ?? "https://bit.ly/3Lstjcq";
      _restaurantDescription = SharedService.prefs.getString('description')!;
    });
  }

  Future<void> removeOffer(String idOffer) async {
    bool response = await APIService.removeOffer(idOffer);
    if (response) {
      setOffers();
    }
  }

  void _updateReload(bool value) {
    setState(() {
      reload = value;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (reload) {
      setState(() {
        setOffers();
        getRestaurantDetails();
        reload = false;
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(207, 255, 86, 34),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          CachedNetworkImageProvider(_restaurantPhoto)),
                  const SizedBox(height: 10),
                  Text(
                    _restaurantName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _restaurantEmail,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_offer,
                  color: Color.fromARGB(220, 255, 86, 34)),
              title: const Text('Nueva oferta'),
              onTap: () {
                setState(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NuevaPromo(createOffer: _updateReload),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit,
                  color: Color.fromARGB(220, 255, 86, 34)),
              title: const Text('Editar perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettings(
                        name: _restaurantName,
                        description: _restaurantDescription,
                        photo: _restaurantPhoto, update: _updateReload),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout,
                  color: Color.fromARGB(220, 255, 86, 34)),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Functions.logout(context);
              },
            ),
          ],
        ),
      ),
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
                actions: <Widget>[
                  IconButton(
                    color: Colors.white,
                    onPressed: () {
                      SharedService.prefs.clear();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ],
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
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 8),
                      Visibility(
                        visible: _isVisible,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    _restaurantName,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    _restaurantAddress,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
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
                return OfertaRestaurante(
                    removeOffer: removeOffer,
                    id: offerss[index].id!,
                    description: offerss[index].description!,
                    photo: offerss[index].photo!,
                    price: offerss[index].price!,
                    restaurantName: _restaurantName,
                    title: offerss[index].name!);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NuevaPromo(createOffer: _updateReload),
            ),
          );
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
