import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class ButtonOne extends StatelessWidget {
  Function onClick;
  String text;

  ButtonOne(
      {super.key, required this.onClick, required this.text});

  
  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.symmetric(vertical: 25),
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        minimumSize:
            MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(HexColor('#E64A19')),
      ),
      onPressed: () => onClick(),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
    ),
  );
  }
}
