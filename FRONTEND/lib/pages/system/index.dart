import 'package:integrador/widgets/biometric_data.dart';
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
  double precioo = 0;

  String typeOfView = 'list';
  late Widget view = Container();
  List<Offer> offerss = <Offer>[];
  List<Restaurant> restaurants = <Restaurant>[];
  List<Restaurant> restaurantsFavs = <Restaurant>[];
  double _maxPrice = 0;
  double priceMax = 0;
  bool switchValue = false;

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

  Position? currentLocation;
  double latit = 00.0;
  double longit = -0.00;
  String? selectedCity;
  String? selectedLocation;
  LatLng? selectedLocationLatLng;

  /* ================ Filter's variables ========= */
  PriceFilter priceFilter =
      PriceFilter(maxPrice: 0, rangeValues: const RangeValues(0, 0));
  late String selectedValue;

  /* ==================Functions================= */

  @override
  void initState() {
    super.initState();
    setOffers();
    setRestaurants();
    setMaxPrice();
    setState(() {
      selectedValue = selectedCity ?? "Ninguna ciudad seleccionada";
      _name = SharedService.prefs.getString("name") ?? "User name";
      _email = SharedService.prefs.getString("email") ?? "Correo electrónico";
      _photo =
          SharedService.prefs.getString("photo") ?? "https://bit.ly/3Lstjcq";
    });
    setRestaurantsInformation();
  }

  void disabledLocation() async {
    bool desactivar = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Desactivar ubicación'),
          content: const Text(
              '¿Estás seguro de que deseas desactivar la ubicación?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Desactivar'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (desactivar) {
      await Geolocator.openLocationSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ubicación desactivada'),
            content:
                const Text('Por favor, active la ubicación para continuar.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.deepOrange)),
                onPressed: () {
                  switchValue = false;
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Aceptar',
                    style: TextStyle(color: Colors.deepOrange)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );
      if (!result) {
        return Future.error('Location services are disabled.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        bool result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Permiso de ubicación denegado'),
              content: const Text(
                  'Por favor, otorgue el permiso de ubicación para continuar.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.deepOrange)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.deepOrange)),
                  onPressed: () {
                    switchValue = true;
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
        if (!result) {
          return Future.error('Location permissions are denied');
        }
      }
    }

    try {
      // Obtener la ubicación actual del usuario
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = position;
        selectedLocation = '${position.latitude}, ${position.longitude}';
        selectedLocationLatLng = LatLng(position.latitude, position.longitude);
        latit = position.latitude;
        longit = position.longitude;
      });
    } catch (e) {
      e.toString();
    }
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

  Future<List<Restaurant>> getRestaurantByFavorites() async {
    var restFavs = await APIService.getFavorites();
    return restFavs;
  }

  Future<void> setRestaurants() async {
    await getRestaurantByFavorites().then((value) {
      setState(() {
        restaurantsFavs.clear();
        restaurantsFavs.addAll(value);
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
        if (value == -1) {
          _maxPrice = 1;
          precioo = value;
        } else {
          _maxPrice = value;
          precioo = value;
        }
      });
    });
  }

  Future<double> getMaxPrice() async {
    var maxPriceApi = await APIService.getMaxPriceAllOffers();
    return maxPriceApi;
  }

  Future<void> onSwitchChanged(bool value) async {
    if (value) {
      _getCurrentLocation();
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (isLocationEnabled != true) {
        value = false;
      }
    } else {
      disabledLocation();
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      setState(() {
        value = isLocationEnabled;
      });
    }

    setState(() async {
      switchValue = value;
    });
  }

  /* ================= Filter's functions ============= */

  Future<void> _deleteValues() async {
    selectedValue = "";
    _maxPrice = precioo;
    priceFilter =
        PriceFilter(maxPrice: 0, rangeValues: RangeValues(0, _maxPrice));

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
          .then((value) => {
                if (Navigator.canPop(context)) {Navigator.pop(context)},
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
          .then((value) => {
                if (Navigator.canPop(context)) {Navigator.pop(context)},
                setState(() {
                  _isDoingFetch = false;
                })
              });
    }
  }

  void showModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
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
                        maxPrice: _maxPrice,
                        rangeValues: RangeValues(0, _maxPrice))
                    : priceFilter,
                IgnorePointer(
                  ignoring: _isDoingFetch,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              HexColor('#E64A19')),
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
                                .then((value) => {
                                      if (Navigator.canPop(context))
                                        {Navigator.pop(context)},
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
                                .then((value) => {
                                      if (Navigator.canPop(context))
                                        {Navigator.pop(context)},
                                      setState(() {
                                        _isDoingFetch = false;
                                      })
                                    });
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              HexColor('#E64A19')),
                        ),
                        child: const Text('Eliminar filtros'),
                        onPressed: () {
                          setState(() {
                            _isDoingFetch = true;
                          });
                          _deleteValues();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
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
    return Stack(
      children: [
        IgnorePointer(
          ignoring: _isDoingFetch,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Flex(
                direction: Axis.horizontal,
                children: [
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
                      color: Colors.deepOrange,
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
                    leading: const Icon(Icons.home, color: Colors.deepOrange),
                    title: const Text('Inicio'),
                    onTap: () {
                      setState(
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Index(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.favorite, color: Colors.deepOrange),
                    title: const Text('Restaurantes favoritos'),
                    onTap: () {
                      setState(
                        () {
                          setRestaurants();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantFavorites(
                                restaurants: restaurantsFavs,
                                userName: _name,
                                email: _email,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Ubicación'),
                    value: switchValue,
                    onChanged: onSwitchChanged,
                    secondary:
                        const Icon(Icons.location_on, color: Colors.deepOrange),
                  ),
                  ListTile(
                    leading: const Icon(Icons.map, color: Colors.deepOrange),
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
                  ExpansionTile(
                    title: const Text(
                      'Panel de Filtros',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    leading: const Icon(Icons.filter_alt_outlined,
                        color: Colors.deepOrange),
                    textColor: Colors.deepOrange,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ListTile(
                          leading: const Icon(Icons.filter_alt,
                              color: Colors.deepOrange),
                          title: const Text("Seleccionar valores"),
                          onTap: () {
                            Navigator.pop(context);
                            showModal();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ListTile(
                          leading: const Icon(Icons.location_city,
                              color: Colors.deepOrange),
                          title: Text(selectedValue),
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ListTile(
                          leading: const Icon(Icons.monetization_on,
                              color: Colors.deepOrange),
                          title: Text(
                              '\$ ${priceFilter.getMinPrice()}  -  \$ ${priceFilter.getMaxPrice()}'),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text(
                      'Cuenta',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    leading: const Icon(Icons.account_circle,
                        color: Colors.deepOrange),
                    textColor: Colors.deepOrange,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ListTile(
                          leading: const Icon(Icons.mode_edit,
                              color: Colors.deepOrange),
                          title: const Text('Editar cuenta'),
                          onTap: () {
                            // Aquí va la lógica para navegar a la pantalla de editar cuenta
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ListTile(
                          leading: const Icon(Icons.fingerprint,
                              color: Colors.deepOrange),
                          title: const Text('Datos biométricos'),
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              view = const BiometricData();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.deepOrange),
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 20, right: 15),
                  child: Deslizar(restaurants: restaurants),
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
