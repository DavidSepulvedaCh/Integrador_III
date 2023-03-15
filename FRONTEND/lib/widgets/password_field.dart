import 'package:integrador/routes/imports.dart';

// ignore: must_be_immutable
class PasswordField extends StatelessWidget {
  TextEditingController textEditingController;
  String hintText;
  String labelText;

  PasswordField(
      {super.key, required this.textEditingController, required this.labelText, required this.hintText});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelText,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                  color: Colors.black38, blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          height: 60,
          child: TextField(
            controller: textEditingController,
            obscureText: true,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 15),
                prefixIcon: Icon(Icons.lock, color: HexColor('#E64A19')),
                hintText: hintText,
                hintStyle: TextStyle(color: HexColor('#212121'))),
          ),
        )
      ],
    );
  }
}