import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/screens/rutas.dart';

class CustomFadeImageNetwork extends StatelessWidget {
  const CustomFadeImageNetwork({Key? key, required this.imageUrl})
      : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == '') {
      return Image.asset('${Rutas.imageRute}no_image.png', fit: BoxFit.contain);
    } else {
      return FadeInImage(
        placeholder: AssetImage('${Rutas.imageRute}image-loading.gif'),
        image: CachedNetworkImageProvider(imageUrl),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset('${Rutas.imageRute}no_image.png',
              fit: BoxFit.contain);
        },
        fit: BoxFit.contain,
      );
    }
  }
}
