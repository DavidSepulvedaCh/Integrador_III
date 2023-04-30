import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:integrador/routes/imports.dart';

class Deslizar extends StatefulWidget {
  const Deslizar({Key? key}) : super(key: key);

  @override
  State<Deslizar> createState() => _DeslizarState();
}

class _DeslizarState extends State<Deslizar> {
  late Future<List<Restaurant>> _restaurantsFuture;

  @override
  void initState() {
    super.initState();
    _restaurantsFuture = getRestaurantsInformation();
  }

  Future<List<Restaurant>> getRestaurantsInformation() async {
    final register = await APIService.getInformationOfAllRestaurants();
    return register;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Restaurant>>(
      future: _restaurantsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final restaurants = snapshot.data!;
            return CarouselSlider.builder(
              itemCount: restaurants.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(111, 175, 175, 175),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Image.network(
                          restaurants[index].photo ?? "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg",
                          height: 65,
                          width: 65,
                        ),
                      ),
                      Text(
                        restaurants[index].name!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                height: 100,
                enlargeCenterPage: false,
                enableInfiniteScroll: true,
                aspectRatio: 16 / 9,
                viewportFraction: 1 / 2,
                initialPage: 0,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
