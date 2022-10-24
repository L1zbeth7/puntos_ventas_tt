import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/screens/screens.dart';
import 'package:puntos_ventas_tt/utils/custom_launch.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class AyudaPventaScreen extends StatelessWidget {
  static String routePage = 'AyudaPventaScreen';
  const AyudaPventaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ayuda'),
        backgroundColor: Colors.black,
        //boton regresar
        // actions: [
        //   IconButton(
        //       icon: const Icon(Icons.arrow_back_ios),
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => const TiendasLoginScreen()));
        //       })
        // ],
      ),
      drawer: DrawerMenu(routeActual: routePage), //menu de opciones
      body: Stack(children: [BackgroundImg(), const _Ayudapv()]),
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
            //boton regresar
            // IconButton(
            //       icon: const Icon(Icons.arrow_circle_left_outlined,
            //           size: 50, color: Color(0xff204884)),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const TiendasLoginScreen()),
            //         );
            //       },
            //     )
          ],
        ),
      ),
      const SizedBox(height: 330),
      Row(
        children: [_BotonRegresar()],
      ),
    ]);
  }
}

class _BotonRegresar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IconButton(
        icon: const Icon(Icons.arrow_circle_left_outlined,
            size: 70, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TiendasLoginScreen()),
          );
        },
      ),
    );
  }
}
