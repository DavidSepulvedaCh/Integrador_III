// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImageLoading extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  const ImageLoading({super.key, required this.imageUrl, this.height, this.width});

  @override
  _ImageLoadingState createState() => _ImageLoadingState();
}

class _ImageLoadingState extends State<ImageLoading> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _isLoading
              ? const SpinKitRing(
                  color: Colors.deepOrange,
                  size: 50.0,
                )
              : Image.network(
                  // ignore: unnecessary_string_interpolations
                  "${widget.imageUrl}",
                  fit: BoxFit.cover,
                  height: widget.height,
                  width: widget.width,
                ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void loadImage() async {
    await Future.delayed(const Duration(
        seconds: 2)); // Simulamos la carga de la imagen durante 2 segundos.
    setState(() {
      _isLoading = false;
    });
  }
}
