import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PriceFilter extends StatefulWidget {
  double maxPrice;
  RangeValues rangeValues;

  PriceFilter({super.key, required this.maxPrice, required this.rangeValues});

  @override
  State<PriceFilter> createState() => _PriceFilterState();

  int getMinPrice() {
    return rangeValues.start.round();
  }

  int getMaxPrice() {
    return rangeValues.end.round();
  }
}

class _PriceFilterState extends State<PriceFilter> {
  // El 1000 es el valor máximo, debe ser igual en ambos lados, max y los atributos
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Precio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          RangeSlider(
            activeColor: Colors.orange, //Color activo
            inactiveColor: Colors.black, //Color inactivo
            values: widget.rangeValues,
            min: 0, //Límite inferior precios
            max: widget.maxPrice, //Límite superior precios
            divisions: 100, //Cambio del valor en el slider, de 100 en 100
            labels: RangeLabels(
              widget.rangeValues.start.round().toString(),
              widget.rangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                widget.rangeValues = values;
              });
            },
          ),
        ],
      ),
    );
  }
}
