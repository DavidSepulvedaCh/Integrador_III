import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class ButtonFavorite extends StatefulWidget {
  String? idRestaurant;

  ButtonFavorite({super.key, this.idRestaurant});

  @override
  State<ButtonFavorite> createState() => _ButtonFavoriteState();
}

class _ButtonFavoriteState extends State<ButtonFavorite> {
  @override
  void initState() {
    super.initState();
    isInFavorites(widget.idRestaurant ?? 'default');
  }

  Color heartColor = Colors.blueGrey;

  isInFavorites(String idRestaurant) async {
    if (idRestaurant == "default" || !mounted) {
      return;
    }
    bool exists = await SQLiteDB.existsFavorite(idRestaurant);
    if (exists) {
      if (mounted) {
        setState(() {
          heartColor = Colors.red;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          heartColor = Colors.blueGrey;
        });
      }
    }
  }

  addFavorite(String idRestaurant) async {
    String idUser = SharedService.prefs.getString('id') ?? 'default';
    if (idUser == 'default' || idRestaurant == 'default') {
      return;
    }
    bool exists = await SQLiteDB.existsFavorite(idRestaurant);
    if (exists) {
      await SQLiteDB.delete(idRestaurant);
      setState(() {
        heartColor = Colors.blueGrey;
      });
    } else {
      Restaurant? restaurant = await APIService.getRestaurantById(idRestaurant);
      if (restaurant != null) {
        await SQLiteDB.insert(restaurant);
        setState(() {
          heartColor = Colors.red;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => addFavorite(widget.idRestaurant ?? 'default'),
      icon: const Icon(Icons.favorite),
      color: heartColor,
      padding: const EdgeInsets.only(left: 0),
      alignment: Alignment.centerLeft,
    );
  }
}
