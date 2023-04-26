import 'package:integrador/routes/imports.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late Widget view = Container();
  int _currentIndex = 0;

  /* ==================Functions================= */

  @override
  void initState() {
    super.initState();
    setOffers();
  }

  Future<void> setOffers() async {
    await getOffers().then((value) {
      setState(() {
        offerss.clear();
        offerss.addAll(value);
        view = ListOffers(offers: offerss);
      });
    });
  }

  List<Offer> offerss = <Offer>[];
  Future<List<Offer>> getOffers() async {
    var register = await SQLiteDB.getFavorites();
    return register;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        setState(() {
          setOffers().then((value) => view = ListOffers(offers: offerss));
        });
        break;
      case 1:
        setState(() {
          setOffers().then((value) => view = GridOffers(offers: offerss));
        });
        break;
      case 2:
        setState(() {
          Navigator.pop(context);
        });
        break;
      case 3:
        Functions.logout(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: view,
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
            icon: Icon(Icons.arrow_back_ios, color: Colors.deepOrange),
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
