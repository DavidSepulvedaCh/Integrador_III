import 'package:integrador/routes/imports.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  late String _name;
  late String _email;
  late String _photo;
  bool _isDoingFetch = false;

  String typeOfView = 'list';
  late Widget view = Container();
  List<Offer> offerss = <Offer>[];
  List<Restaurant> restaurants = <Restaurant>[];
  int _currentIndex = 0;
  double maxPrice = 0;

  List<String> imageUrls = [
    'https://bit.ly/3ngEDPI',
    'https://ubr.to/40XnecM',
    'https://bit.ly/3LfDGz7'
  ];
  List<String> captions = [
    'DelValle BBQ',
    'Porto Burger',
    'Comics Pizza',
  ];

  /* ================ Filter's variables ========= */
  PriceFilter priceFilter =
      PriceFilter(maxPrice: 0, rangeValues: const RangeValues(0, 0));
  String selectedValue = '';

  /* ==================Functions================= */

  @override
  void initState() {
    super.initState();
    setOffers();
    setMaxPrice();
    setState(() {
      _name = SharedService.prefs.getString("name") ?? "User name";
      _email = SharedService.prefs.getString("email") ?? "Correo electrónico";
      _photo =
          SharedService.prefs.getString("photo") ?? "https://bit.ly/3Lstjcq";
    });
    setRestaurantsInformation();
  }

  Future<void> setRestaurantsInformation() async {
    await getRestaurantsInformation().then((value) {
      setState(() {
        restaurants.addAll(value);
      });
    });
  }

  Future<List<Restaurant>> getRestaurantsInformation() async {
    var register = await APIService.getInformationOfAllRestaurants();
    return register;
  }

  Future<void> setOffers() async {
    await getOffers().then((value) {
      setState(() {
        offerss.addAll(value);
        if (typeOfView == 'list') {
          view = ListOffers(offers: offerss);
        } else {
          view = GridOffers(offers: offerss);
        }
      });
    });
  }

  Future<List<Offer>> getOffers() async {
    var register = await APIService.getOffers();
    return register;
  }

  Future<void> setOffersByPriceRange() async {
    await getOffersByPriceRange().then((value) {
      setState(() {
        offerss.clear();
        offerss.addAll(value);
      });
    });
  }

  Future<List<Offer>> getOffersByPriceRange() async {
    var register = await APIService.getOffersByPriceRange(
        priceFilter.getMinPrice(), priceFilter.getMaxPrice());
    return register;
  }

  Future<void> setOffersByCity() async {
    await getOffersByCity().then((value) {
      setState(() {
        offerss.clear();
        offerss.addAll(value);
      });
    });
  }

  Future<List<Offer>> getOffersByCity() async {
    var register = await APIService.getOffersByCity(selectedValue);
    return register;
  }

  Future<void> setOffersByCityAndPriceRange() async {
    await getOffersByCityAndPriceRange().then((value) {
      setState(() {
        offerss.clear();
        offerss.addAll(value);
      });
    });
  }

  Future<List<Offer>> getOffersByCityAndPriceRange() async {
    var register = await APIService.getOffersByCityAndPriceRange(
        selectedValue, priceFilter.getMinPrice(), priceFilter.getMaxPrice());
    return register;
  }

  Future<void> setMaxPrice() async {
    await getMaxPrice().then((value) {
      setState(() {
        maxPrice = value;
      });
    });
  }

  Future<double> getMaxPrice() async {
    var maxPriceApi = await APIService.getMaxPriceAllOffers();
    return maxPriceApi;
  }

  /* ================= Filter's functions ============= */

  void showModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: ((BuildContext context, StateSetter setState) {
            return Column(
              children: <Widget>[
                const SizedBox(height: 15),
                Flexible(
                  flex: 1,
                  child: RadioListTile(
                      title: const Text('Bucaramanga'),
                      value: 'Bucaramanga',
                      selected: selectedValue == 'Bucaramanga',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedValue = value);
                        }
                      }),
                ),
                Flexible(
                  flex: 1,
                  child: RadioListTile(
                      title: const Text('Piedecuesta'),
                      value: 'Piedecuesta',
                      selected: selectedValue == 'Piedecuesta',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedValue = value);
                        }
                      }),
                ),
                Flexible(
                  flex: 1,
                  child: RadioListTile(
                      title: const Text('Girón'),
                      value: 'Girón',
                      selected: selectedValue == 'Girón',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedValue = value);
                        }
                      }),
                ),
                Flexible(
                  flex: 1,
                  child: RadioListTile(
                      title: const Text('Floridablanca'),
                      value: 'Floridablanca',
                      selected: selectedValue == 'Floridablanca',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedValue = value);
                        }
                      }),
                ),
                priceFilter = priceFilter.maxPrice == 0
                    ? PriceFilter(
                        maxPrice: maxPrice,
                        rangeValues: RangeValues(0, maxPrice))
                    : priceFilter,
                IgnorePointer(
                  ignoring: _isDoingFetch,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(HexColor('#E64A19')),
                    ),
                    child: const Text('Aceptar'),
                    onPressed: () {
                      setState(() {
                        _isDoingFetch = true;
                      });
                      if (selectedValue.isEmpty) {
                        setOffersByPriceRange()
                            .then((value) => {
                                  setState(() {
                                    if (typeOfView == 'list') {
                                      view = ListOffers(offers: offerss);
                                    } else {
                                      view = GridOffers(offers: offerss);
                                    }
                                  })
                                })
                            .then((value) => {Navigator.pop(context)})
                            .then((value) => {
                                  Navigator.pop(context),
                                  setState(() {
                                    _isDoingFetch = false;
                                  })
                                });
                      } else {
                        setOffersByCityAndPriceRange()
                            .then((value) => {
                                  setState(() {
                                    if (typeOfView == 'list') {
                                      view = ListOffers(offers: offerss);
                                    } else {
                                      view = GridOffers(offers: offerss);
                                    }
                                  })
                                })
                            .then((value) => {Navigator.pop(context)})
                            .then((value) => {
                                  Navigator.pop(context),
                                  setState(() {
                                    _isDoingFetch = false;
                                  })
                                });
                      }
                    },
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Flex(
          direction: Axis.horizontal, children: [
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  const Flexible(
                    flex: 1,
                    child: Text(
                      'FOODHUB',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(_photo),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
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
                    backgroundImage: CachedNetworkImageProvider(_photo),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite,
                  color: Color.fromARGB(220, 255, 86, 34)),
              title: const Text('Mis favoritos'),
              onTap: () {
                setState(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Favorites(),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter_alt,
                  color: Color.fromARGB(220, 255, 86, 34)),
              title: const Text('filtros'),
              onTap: () {
                showModal();
              },
            ),
            ListTile(
              leading: const Icon(Icons.map,
                  color: Color.fromARGB(220, 255, 86, 34)),
              title: const Text('Mapa'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapSample(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit,
                  color: Color.fromARGB(220, 255, 86, 34)),
              title: const Text('Editar perfil'),
              onTap: () {},
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
        mainAxisSize: MainAxisSize.min,
        children: [
          //filtrosBuild(),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Nuestros restaurantes: ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, bottom: 20, right: 15),
            child: Deslizar(),
          ),
          const Divider(
            thickness: 0.8,
            color: Color.fromARGB(82, 88, 88, 87),
            indent: 20,
            endIndent: 20,
          ),

          Flexible(child: view),
        ],
      ),
    );
  }
}
