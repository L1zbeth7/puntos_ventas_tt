import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/screens/screens.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class TiendasLoginScreen extends StatelessWidget {
  static String routePage = 'TiendasLoginScreen';
  const TiendasLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        BackgroundImg(),
        Center(
          child: Column(
            mainAxisSize:
                MainAxisSize.min, //visualiza la vista a la mitad de la pantalla
            children: const [
              Text(
                'Ventas Tlati',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              _CardSelectTienda(),
            ],
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Colores.secondaryColor, shape: BoxShape.circle),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
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
    // final tiendaController = Provider.of<>(context);
    //propiedades background Card
    return Container(
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //     colors: coloresGradiante,
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white30,
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
            children: [
              const Icon(
                Icons.store_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('Tienda')),
                  ],
                  value: '1',
                  //items: getItemTiendas(context),
                  isExpanded: true, borderRadius: BorderRadius.circular(25),
                  decoration: const InputDecoration(border: InputBorder.none),

                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          /* ________________________________________________________________ */
          const Text('Sucursal:',
              style: TextStyle(fontSize: 19, color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('Sucursal')),
                  ],
                  value: '1',
                  //items: getItemTiendas(context),
                  isExpanded: true, borderRadius: BorderRadius.circular(25),
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end, //pocisiona al boton
            children: [
              TextButton(
                style: StyleTexto.getCustomButtonStyle2(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white),
                child: const Text('Ingresar',
                    style: TextStyle(color: Color(0xff204884), fontSize: 16)),
                onPressed: () async {
                  //print('boton ingresar');
                  // const AyudaPventaScreen();
                  // Navigator.pop(context);

                  Navigator.pushReplacementNamed(
                      context, AyudaPventaScreen.routePage);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
