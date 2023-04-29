import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSliderWidget extends StatelessWidget {
  final List<String> imageUrls;
  final List<String> captions;

  const ImageSliderWidget(
      {super.key, required this.imageUrls, required this.captions});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: imageUrls.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(147, 175, 175, 175),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Image.network(
                  imageUrls[index],
                  height: 65,
                  width: 65,
                ),
              ),
              Text(
                captions[index],
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 100,
        enlargeCenterPage: false,
        enableInfiniteScroll: true,
        aspectRatio: 16 / 9, // Proporción de aspecto de los elementos
        viewportFraction: 1 /
            3, // Fracción de la pantalla que ocupan los elementos (en este caso, 1/4 para mostrar 4 elementos)
        initialPage: 0, // Página inicial
        reverse: false, // Desplazamiento en orden inverso
        autoPlay: true, // Reproducción automática
        autoPlayInterval: const Duration(
            seconds:
                3), // Intervalo de tiempo entre cada reproducción automática
        autoPlayAnimationDuration: const Duration(
            milliseconds:
                800), // Duración de la animación de reproducción automática
        autoPlayCurve: Curves
            .fastOutSlowIn, // Curva de animación de reproducción automática
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
