import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class ButtonFavorite extends StatefulWidget {
  String? idRestaurant;
  final Function(bool) setDoingFetch;
  final Function()? update;

  ButtonFavorite(
      {super.key, this.idRestaurant, required this.setDoingFetch, this.update});

  @override
  State<ButtonFavorite> createState() => _ButtonFavoriteState();
}

class _ButtonFavoriteState extends State<ButtonFavorite> {
  bool _favorite = false;

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
          _favorite = true;
          heartColor = Colors.red;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _favorite = false;
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
    setState(() {
      widget.setDoingFetch(true);
    });
    bool exists = await SQLiteDB.existsFavorite(idRestaurant);
    if (exists) {
      await APIService.removeFavorite(idRestaurant).then((value) => {
            if (value)
              {
                CustomShowDialog.make(
                    context, "Éxito", "Se eliminó el restaurante de favoritos"),
                setState(() {
                  heartColor = Colors.blueGrey;
                  widget.setDoingFetch(false);
                  _favorite = false;
                  if (widget.update != null) {
                    widget.update!();
                  }
                }),
                SQLiteDB.delete(idRestaurant)
              }
            else
              {
                CustomShowDialog.make(context, "Error",
                    "No se pudo eliminar el restaurante de favoritos"),
                setState(() {
                  widget.setDoingFetch(false);
                })
              }
          });
    } else {
      Restaurant? restaurant = await APIService.getRestaurantById(idRestaurant);
      if (restaurant != null) {
        await APIService.addFavorite(idRestaurant).then((value) => {
              if (value)
                {
                  CustomShowDialog.make(
                      context, "Éxito", "Se agregó el restaurante a favoritos"),
                  setState(() {
                    heartColor = Colors.red;
                    widget.setDoingFetch(false);
                    _favorite = true;
                    if (widget.update != null) {
                      widget.update!();
                    }
                  }),
                  SQLiteDB.insert(restaurant)
                }
              else
                {
                  CustomShowDialog.make(context, "Error",
                      "No se pudo agregar el restaurante a favoritos"),
                  setState(() {
                    widget.setDoingFetch(false);
                  })
                }
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: _favorite
                  ? const Text('Confirmación eliminar de favoritos')
                  : const Text('Confimación agregar a favoritos'),
              content: _favorite
                  ? const Text(
                      '¿Estás seguro de eliminar el restaurante a favoritos?')
                  : const Text(
                      '¿Estás seguro de agregar el restaurante a favoritos?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    addFavorite(widget.idRestaurant ?? 'default');
                  },
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(
        Icons.favorite,
        size: 35,
      ),
      color: heartColor,
      padding: const EdgeInsets.only(left: 0),
      alignment: Alignment.centerLeft,
    );
  }
}
