import 'package:carousel_slider/carousel_slider.dart';
import 'package:integrador/routes/imports.dart';

class Deslizar extends StatefulWidget {
  final List<Restaurant> restaurants;

  const Deslizar({Key? key, required this.restaurants}) : super(key: key);

  @override
  State<Deslizar> createState() => _DeslizarState();
}

class _DeslizarState extends State<Deslizar> {
  // ignore: unused_field
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.restaurants.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.restaurants.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantSelected(
                      restaurant: widget.restaurants[index],
                    ),
                  ),
                );
              },
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(110, 216, 216, 216),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Image.network(
                        widget.restaurants[index].photo ??
                            "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg",
                        height: 65,
                        width: 65,
                      ),
                    ),
                    Text(
                      widget.restaurants[index].name!,
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
            onPageChanged: (index, _) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}
