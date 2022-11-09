import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/utils/custom_launch.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class AyudaPventaScreen extends StatelessWidget {
  static String routePage = 'AyudaPventaScreen';
  const AyudaPventaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Ayuda'),
          backgroundColor: Colors.black,
        ),
        drawer: DrawerMenu(routeActual: routePage), //menu de opciones
        body: Stack(children: [BackgroundImg(), const _Ayudapv()]),
      ),
    );
  }
}

//contenido
class _Ayudapv extends StatelessWidget {
  const _Ayudapv({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Center(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            //const Text('Ayuda', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            const Text('Telefono de ayuda:',
                style: TextStyle(fontSize: 24, color: Colors.white)),
            const Text('xxx-xxx-xxxx',
                style: TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 30),
            const Text('Esquema de Funcionamineto:',
                style: TextStyle(fontSize: 24, color: Colors.white)),
            TextButton(
              child: const Text('Esquema',
                  style: TextStyle(fontSize: 22, color: Colors.yellow)),
              onPressed: () async {
                CustomLaunch.launchWeb('bit.ly/3FqQ8b9'); //redirecciona
              },
            ),
            const SizedBox(height: 25),
            const Text('Visita Tlati Digital',
                style: TextStyle(fontSize: 24, color: Colors.white)),
            TextButton(
              child: const Text('Pagina Web',
                  style: TextStyle(fontSize: 22, color: Colors.yellow)),
              onPressed: () async {
                CustomLaunch.launchWeb('ttland.com.mx/'); //manda a esa pagina
              },
            ),
          ],
        ),
      ),
    ]);
  }
}
