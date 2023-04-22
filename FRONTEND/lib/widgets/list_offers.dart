import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class ListOffers extends StatelessWidget {
  List<Offer> offers;

  ListOffers({super.key, required this.offers});

  Widget _resena() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nombre del usuario',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Fecha de la reseña',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Título de la reseña',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Contenido de la reseña. Aquí puedes escribir una descripción detallada de la experiencia del usuario.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const Icon(Icons.star_border, color: Colors.amber, size: 20),
                const Icon(Icons.star_border, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '4.0',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Image.network(
              'https://via.placeholder.com/350x150',
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  void _showModal(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      offers[index].photo!,
                    ),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 16,
                      left: 16,
                      child: Text(
                        'Nombre del restaurante',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 48,
                      left: 16,
                      child: Text(
                        'Ubicación del restaurante',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            offers[index].name!,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ButtonFavorite(idOffer: offers[index].id),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        offers[index].description!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Precio: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${offers[index].price!}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 235, 79, 32),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.location_city),
                            label: const Text("¿Como llegar?"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: offers.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showModal(context, index);
                      print("TOCO=====");
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Image.network(offers[index].photo!,
                                      height: 120,
                                      width: 150,
                                      fit: BoxFit.cover),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offers[index].name!,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Raleway'),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      offers[index].description!,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Raleway'),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\$ ${offers[index].price}",
                                      style: const TextStyle(
                                          fontFamily: 'Raleway'),
                                    ),
                                    const SizedBox(height: 8),
                                    ButtonFavorite(idOffer: offers[index].id)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        )
      ],
    ));
  }
}
