import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/screens/screens.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class TiendasLoginScreen extends StatelessWidget {
  static String routePage = 'TiendasLoginScreen';
  const TiendasLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pantalla 1',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login Sucursal'),
          backgroundColor: Colors.black,
        ),
        body: Stack(children: [
          BackgroundImg(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, //visualiza la vista a la mitad de la pantalla
              children: const [
                Text('Ventas Tlati',
                    style:
                        TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                _CardSelectTienda(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _CardSelectTienda extends StatelessWidget {
  const _CardSelectTienda({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //propiedades background Card
    return Container(
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //     colors: coloresGradiante,
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white12,
      ),
      margin: const EdgeInsets.symmetric(
          horizontal: 20), //tamaño de ancho tarjeta (card)
      padding: const EdgeInsets.all(25), //tamaño alto tarjeta
      //contenido de la tarjeta
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, //ajusta(alinea) el texto
        children: [
          const Text('Selecciona la Tienda/Sucursal',
              style: TextStyle(fontSize: 22, color: Colors.white)),
          const SizedBox(height: 15),
          /* ________________________________________________________________ */
          const Text(
            'Tienda:',
            style: TextStyle(fontSize: 19, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(
                Icons.store_outlined,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(height: 15),
            ],
          ),
          const SizedBox(height: 10),
          /* ________________________________________________________________ */
          const Text('Sucursal:',
              style: TextStyle(fontSize: 19, color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(height: 10),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end, //pocisiona al boton
            children: [
              TextButton(
                style: getCustomButtonStyle2(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white),
                child: const Text('Ingresar',
                    style: TextStyle(fontSize: 19, color: Color(0xff204884))),
                onPressed: () {
                  //print('boton ingresar');
                  // const AyudaPventaScreen();
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AyudaPventaScreen()),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

ButtonStyle getCustomButtonStyle2({
  EdgeInsets padding = const EdgeInsets.all(8),
  Color color = const Color(0xff204884),
}) =>
    ButtonStyle(
      elevation: MaterialStateProperty.all(5),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      backgroundColor: MaterialStateProperty.all(color),
      padding: MaterialStateProperty.all(padding),
    );
