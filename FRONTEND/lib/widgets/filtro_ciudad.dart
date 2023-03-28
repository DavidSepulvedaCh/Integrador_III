import 'package:integrador/routes/imports.dart';

class ZonaBottomSheet extends StatefulWidget {
  const ZonaBottomSheet({super.key});

  @override
  State<ZonaBottomSheet> createState() => _ZonaBottomSheetState();
}

class _ZonaBottomSheetState extends State<ZonaBottomSheet> {
  String selectedValue = '';
  String eleccion = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: ElevatedButton.icon(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          backgroundColor:
              MaterialStateProperty.all<Color>(HexColor('#E64A19')),
        ),
        label: const Text(
          'Filtros',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        icon: const Icon(Icons.filter_list),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: ((BuildContext context, StateSetter setState) {
                  return Column(
                    children: <Widget>[
                      const SizedBox(height: 15),
                      RadioListTile(
                          title: const Text('Bucaramanga'),
                          value: 'Bucaramanga',
                          selected: selectedValue == 'Bucaramanga',
                          groupValue: selectedValue,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedValue = value);
                            }
                          }),
                      RadioListTile(
                          title: const Text('Piedecuesta'),
                          value: 'Piedecuesta',
                          selected: selectedValue == 'Piedecuesta',
                          groupValue: selectedValue,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedValue = value);
                            }
                          }),
                      RadioListTile(
                          title: const Text('Girón'),
                          value: 'Girón',
                          selected: selectedValue == 'Girón',
                          groupValue: selectedValue,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedValue = value);
                            }
                          }),
                      RadioListTile(
                          title: const Text('Floridablanca'),
                          value: 'Floridablanca',
                          selected: selectedValue == 'Floridablanca',
                          groupValue: selectedValue,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedValue = value);
                            }
                          }),
                      PriceFilter(),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              HexColor('#E64A19')),
                        ),
                        child: const Text('Aceptar'),
                        onPressed: () {
                          setState(() {
                            eleccion = selectedValue;
                          });
                          Navigator.pop(context, selectedValue);
                        },
                      ),
                    ],
                  );
                }),
              );
            },
          ).then((value) {
            if (value != null) {
              setState(() {
                eleccion = value;
              });
            }
          });
        },
      ),
    );
  }
}
