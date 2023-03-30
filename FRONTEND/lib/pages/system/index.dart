import 'package:integrador/routes/imports.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
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
        offerss.addAll(value);
        view = ListOffers(offers: offerss);
      });
    });
  }

  List<Offer> offerss = <Offer>[];
  Future<List<Offer>> getOffers() async {
    var register = await APIService.getOffers();
    return register;
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
          },
        );
        break;
      case 1:
        setState(
          () {
            view = GridOffers(offers: offerss);
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
        setState(
          () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginRestaurante()));
          },
        );
        break;
      case 4:
        Functions.logout(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de ofertas'),
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
            icon: Icon(Icons.favorite, color: Colors.deepOrange),
            label: 'Favoritos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant, color: Colors.deepOrange),
            label: 'Restaurante',
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
