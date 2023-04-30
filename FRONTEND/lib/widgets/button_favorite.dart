import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class ButtonFavorite extends StatefulWidget {
  String? idOffer;

  ButtonFavorite({super.key, this.idOffer});

  @override
  State<ButtonFavorite> createState() => _ButtonFavoriteState();
}

class _ButtonFavoriteState extends State<ButtonFavorite> {
  @override
  void initState() {
    super.initState();
    isInFavorites(widget.idOffer ?? 'default');
  }

  Color heartColor = Colors.blueGrey;

  isInFavorites(String idOffer) async {
    if (idOffer == "default" || !mounted) {
      return;
    }
    bool exists = await SQLiteDB.existsFavorite(idOffer);
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

  addFavorite(String idOffer) async {
    String idUser = SharedService.prefs.getString('id') ?? 'default';
    if (idUser == 'default' || idOffer == 'default') {
      return;
    }
    bool exists = await SQLiteDB.existsFavorite(idOffer);
    if (exists) {
      await SQLiteDB.delete(idOffer);
      setState(() {
        heartColor = Colors.blueGrey;
      });
    } else {
      Offer? product = await APIService.getOfferById(idOffer);
      if (product != null) {
        await SQLiteDB.insert(product);
        setState(() {
          heartColor = Colors.red;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => addFavorite(widget.idOffer ?? 'default'),
      icon: const Icon(Icons.favorite),
      color: heartColor,
      padding: const EdgeInsets.only(left: 0),
      alignment: Alignment.centerLeft,
    );
  }
}
