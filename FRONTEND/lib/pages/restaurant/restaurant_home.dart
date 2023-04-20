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

  @override
  void initState() {
    super.initState();
    getRestaurantDetails();
    _scrollController.addListener(() {
      final isAppBarHidden = _scrollController.offset > 0;
      if (isAppBarHidden != _isAppBarHidden) {
        setState(() {
          _isAppBarHidden = isAppBarHidden;
        });
      }
    });
  }

  Future<void> getRestaurantDetails() async {
    await APIService.getRestaurantDetails();
    setState(() {
      _restaurantName = SharedService.prefs.getString('name') ?? "Restaurante";
      _restaurantAddress = SharedService.prefs.getString('address') ?? "Colombia";
    });
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
              itemCount: 7,
              itemBuilder: (context, index) {
                return const OfertaRestaurante();
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
