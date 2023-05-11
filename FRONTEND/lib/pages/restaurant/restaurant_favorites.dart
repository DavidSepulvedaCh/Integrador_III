import 'package:integrador/routes/imports.dart';

class RestaurantFavorites extends StatefulWidget {
  final List<Restaurant> restaurants;
  final String userName;
  final String email;

  const RestaurantFavorites(
      {Key? key,
      required this.restaurants,
      required this.userName,
      required this.email})
      : super(key: key);

  @override
  State<RestaurantFavorites> createState() => _RestaurantFavoritesState();
}

class _RestaurantFavoritesState extends State<RestaurantFavorites> {
  @override
  void initState() {
    super.initState();
    _setRestaurants();
  }

  Future<void> _setRestaurants() async {
    await Functions.getRestaurantByFavorites().then((value) {
      setState(() {
        widget.restaurants.clear();
        widget.restaurants.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.deepOrange,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  const Flexible(
                    flex: 3,
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
                    flex: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
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
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hola $widget.userName, estos son tus restaurantes favoritos",
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 20),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: widget.restaurants.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantSelected(
                            restaurant: widget.restaurants[index],
                            update: _setRestaurants,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GridTile(
                        footer: GridTileBar(
                          backgroundColor: Colors.black45,
                          title: Text(
                            widget.restaurants[index].name!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        child: Image.network(
                          widget.restaurants[index].photo!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
