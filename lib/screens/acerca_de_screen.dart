import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/utils/custom_launch.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class AcercaDeScreen extends StatelessWidget {
  static String routePage = 'AcercaDeScreen';

  const AcercaDeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Acerca De'),
          backgroundColor: Colors.black,
          //boton regresar
          // actions: [
          //   IconButton(
          //       icon: const Icon(Icons.arrow_back_ios),
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const AyudaPventaScreen()));
          //       })
          // ],
        ),
        drawer: DrawerMenu(routeActual: routePage), //menu de opciones
        body: Stack(children: [BackgroundImg(), _Acercade()]),
      ),
    );
  }
}

class _Acercade extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Center(
          child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
            const SizedBox(height: 30),
            const Text('Proyecto:',
                style: TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 10),
            const Text('Sistema de Gestión',
                style: TextStyle(fontSize: 23, color: Colors.white)),
            const Text('y Administración Tlati',
                style: TextStyle(fontSize: 23, color: Colors.white)),
            const SizedBox(height: 30),
            const Text('Empresa: ',
                style: TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 5),
            // const Text('Tlati Digital',
            //     style: TextStyle(fontSize: 26, color: Colors.yellow)),
            // const SizedBox(height: 25),
            // const Text('Visita Tlati Digital',
            //     style: TextStyle(fontSize: 24, color: Colors.white)),
            TextButton(
              child: const Text('Tlati Digital',
                  style: TextStyle(fontSize: 26, color: Colors.yellow)),
              onPressed: () async {
                CustomLaunch.launchWeb('ttland.com.mx/'); //manda a esa pagina
              },
            ),
          ])),
    ]);
  }
}
