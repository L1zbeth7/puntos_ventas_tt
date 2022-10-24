import 'dart:math';

import 'package:flutter/cupertino.dart';

class BackgroundImg extends StatelessWidget {
  static String routePage = 'BackgroundImg';

  final coloresBackground = BoxDecoration(
      gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: coloresGradiante,
  ));

  BackgroundImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: coloresBackground),
        const ImagenFondoWidget(),
      ],
    );
  }
}

class ImagenFondoWidget extends StatelessWidget {
  ///Imagen(Logo app) rotada pi * 0.20 en la posicion bottom: -75, right: -250,
  ///
  ///![](http://192.168.100.200/capturas/Screenshot_20220809-112808.png)
  const ImagenFondoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      bottom: -75,
      right: -250,
      child: SizedBox(
        width: size.width,
        height: size.width,
        // color: Colors.red,
        child: Transform.rotate(
            angle: pi * .2,
            child: Image.asset('assets/logo_app2.png', fit: BoxFit.cover)),
      ),
    );
  }
}

List<Color> get coloresGradiante => [
      const Color(0xff204884),
      const Color(0xff345fa9),
      const Color(0xff94a6ea),
      // const Color(0xff9037e7),
      // const Color(0xff999eeb),
      // const Color(0xff94a6ea),
    ];

class FondoGradienteWidget extends StatelessWidget {
  ///Widget para agregar un fondo de pantalla con un gradiente de colores en tonalidades azules
  const FondoGradienteWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: coloresGradiante,
        ),
      ),
    );
  }
}
