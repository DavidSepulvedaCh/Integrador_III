import 'package:integrador/routes/imports.dart';
import 'package:http/http.dart' as http;

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  String typeOfView = 'list';
  late Widget view = Container();
  List<Offer> offerss = <Offer>[];
  int _currentIndex = 0;
  double maxPrice = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        setState(
          () {
            view = ListOffers(offers: offerss);
            typeOfView = 'list';
          },
        );
        break;
      case 1:
        setState(
          () {
            view = GridOffers(offers: offerss);
            typeOfView = 'grid';
          },
        );
        break;
      case 2:
        setState(
          () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Favorites()));
          },
        );
        break;

      case 3:
        Functions.logout(context);
        break;
    }
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
                RadioListTile(
                    title: const Text('Bucaramanga'),
                    value: 'Bucaramanga',
                    selected: selectedValue == 'Bucaramanga',
                    groupValue: selectedValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedValue = value);
                      }
                    }),
                RadioListTile(
                    title: const Text('Piedecuesta'),
                    value: 'Piedecuesta',
                    selected: selectedValue == 'Piedecuesta',
                    groupValue: selectedValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedValue = value);
                      }
                    }),
                RadioListTile(
                    title: const Text('Girón'),
                    value: 'Girón',
                    selected: selectedValue == 'Girón',
                    groupValue: selectedValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedValue = value);
                      }
                    }),
                RadioListTile(
                    title: const Text('Floridablanca'),
                    value: 'Floridablanca',
                    selected: selectedValue == 'Floridablanca',
                    groupValue: selectedValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedValue = value);
                      }
                    }),
                priceFilter = priceFilter.maxPrice == 0
                    ? PriceFilter(
                        maxPrice: maxPrice,
                        rangeValues: RangeValues(0, maxPrice))
                    : priceFilter,
                ElevatedButton(
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
                  onPressed: () async {
                    if (selectedValue.isEmpty) {
                      await setOffersByPriceRange();
                      setState(() {
                        if (typeOfView == 'list') {
                          view = ListOffers(offers: offerss);
                        } else {
                          view = GridOffers(offers: offerss);
                        }
                      });
                    } else {
                      await setOffersByCityAndPriceRange();
                      setState(() {
                        if (typeOfView == 'list') {
                          view = ListOffers(offers: offerss);
                        } else {
                          view = GridOffers(offers: offerss);
                        }
                      });
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, selectedValue);
                  },
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
        title: const Text('Lista de ofertas'),
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu), // Icono a mostrar
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
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
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://bit.ly/3Lstjcq'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "User Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Correo electrónico',
                    style: TextStyle(
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Favorites()));
                  },
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
          Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  const Text(
                      '¡Para mayor facilidad seleccione los filtros de tu preferencia!'),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                HexColor('#E64A19')),
                          ),
                          label: const Text(
                            'Filtros',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {
                            showModal();
                          })),
                  // ZonaBottomSheet(maxPrice: maxPrice),
                ],
              )),
          Flexible(child: view)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.deepOrange),
            label: 'Lista',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_4x4, color: Colors.deepOrange),
            label: 'Grilla',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.deepOrange),
            label: 'Favoritos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.deepOrange),
            label: 'Salir',
          ),
        ],
        selectedLabelStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}
