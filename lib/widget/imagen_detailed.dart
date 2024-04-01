import 'package:flutter/material.dart';

class ImageDetail extends StatelessWidget {
  final String imageData;

  const ImageDetail({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Imagen en detalle"),
      ),
      body: Center(
        child: Image.network(imageData),
      ),
    );
  }
}
