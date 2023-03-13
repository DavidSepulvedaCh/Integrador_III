import 'package:flutter/material.dart';

class CustomShowDialog {

  static Future<dynamic> make(BuildContext context, String title, String content){
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Ok')),
                ],
              ));
  }
}
