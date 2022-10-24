import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class EscritorioScreen extends StatelessWidget {
  static String routePage = 'EscritorioScreen';
  const EscritorioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar.AppbarStyle(title: 'Escritorio'),
      drawer: DrawerMenu(routeActual: routePage),
      body: Stack(children: [
        BackgroundImg(),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              _ComprasCard(),
              const SizedBox(height: 25),
              _GraficaCompras(),
              const SizedBox(height: 25),
              _VentasCard(),
              const SizedBox(height: 25),
              _GraficaVentas(),
            ],
          ),
        ),
      ]),
    );
  }
}

class _ComprasCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.blue[400]),
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total compra hoy \$',
                style: StyleTexto.styleTextTitle,
              ),
              const SizedBox(height: 15),
              Text('Compras', style: StyleTexto.styleTextTitle),
              const SizedBox(height: 15),
            ],
          ),
        ),
        Positioned(
            bottom: -6,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              child: TextButton(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Compras', style: StyleTexto.styleTextbutton),
                    const SizedBox(height: 5), //separacion texto y icono
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    )
                  ],
                ),
                //falta style
                onPressed: () {
                  print('Boton Compras');
                },
              ),
            ))
      ]),
    );
  }
}

class _GraficaCompras extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black12,
      ),
    );
  }
}

class _VentasCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.green),
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [],
          ),
        ),
        Positioned(
            bottom: -6,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ventas',
                      style: StyleTexto.styleTextbutton,
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.arrow_forward_ios, color: Colors.black)
                  ],
                ),
                onPressed: () {},
              ),
            ))
      ]),
    );
  }
}

class _GraficaVentas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.black12),
      //SfCartesianChart
    );
  }
}
