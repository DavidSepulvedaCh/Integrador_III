import 'package:carousel_slider/carousel_slider.dart';
import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class Deslizar extends StatefulWidget {
  List<Restaurant> restaurants;

  Deslizar({super.key, required this.restaurants});

  @override
  State<Deslizar> createState() => _DeslizarState();
}

class _DeslizarState extends State<Deslizar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.restaurants.isEmpty){
      return Container();
    }
    return CarouselSlider.builder(
      itemCount: widget.restaurants.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Container(
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
}
