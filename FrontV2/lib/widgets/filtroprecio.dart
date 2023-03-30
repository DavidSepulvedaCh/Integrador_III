import 'package:flutter/material.dart';

class PriceFilter extends StatefulWidget {
  @override
  _PriceFilterState createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  RangeValues _currentRangeValues = const RangeValues(0, 50000);
  // El 50000 es el valor máximo, debe ser igual en ambos lados, max y los atributos
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
            values: _currentRangeValues,
            min: 0, //Límite inferior precios
            max: 50000, //Límite superior precios
            divisions: 100, //Cambio del valor en el slider, de 100 en 100
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
        ],
      ),
    );
  }
}
