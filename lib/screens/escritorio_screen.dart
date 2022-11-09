import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/escritorio_controller.dart';
import 'package:puntos_ventas_tt/models/escritorio_models/compras_ventas_model.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EscritorioScreen extends StatelessWidget {
  static String routePage = 'EscritorioScreen';
  const EscritorioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
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
      ),
    );
  }
}

class _ComprasCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final escritorioController = Provider.of<EscritorioController>(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.blue[400]),
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              escritorioController.isLoading
                  ? CircularProgressIndicator(color: Colores.textColorButton)
                  : Text(
                      'Total compra hoy \$${escritorioController.comprasHoy}',
                      style: StyleTexto.styleTextTitle),
              const SizedBox(height: 15),
              Text('Compras', style: StyleTexto.styleTextSubtitle),
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
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(Colores.backgroundCardColor),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Compras', style: StyleTexto.styleTextSubtitle),
                    const SizedBox(height: 5), //separacion texto y icono
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ))
      ]),
    );
  }
}

class _GraficaCompras extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final escritorioController = Provider.of<EscritorioController>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colores.backgroundCardColor),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(
            text: 'Compras de los últimos 10 días',
            textStyle: StyleTexto.styleLabelForm),
        series: <ChartSeries>[
          BarSeries<ComprasVentasModel, String>(
              animationDelay: 500,
              animationDuration: 1000,
              color: Colores.secondaryColor,
              dataSource: escritorioController.comprasDias,
              name: 'Compras',
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (ComprasVentasModel venta, _) => venta.fecha,
              yValueMapper: (ComprasVentasModel venta, _) => venta.total),
        ],
      ),
    );
  }
}

class _VentasCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final escritorioController = Provider.of<EscritorioController>(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.green),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                escritorioController.isLoading
                    ? CircularProgressIndicator(color: Colores.textColorButton)
                    : Text(
                        'Total venta hoy \$${escritorioController.ventasHoy}',
                        style: StyleTexto.styleTextTitle),
                const SizedBox(height: 15),
                Text('Ventas', style: StyleTexto.styleTextSubtitle),
                const SizedBox(height: 20),
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
                bottomRight: Radius.circular(25),
              ),
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(Colores.backgroundCardColor),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ventas',
                      style: StyleTexto.styleTextSubtitle,
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GraficaVentas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final escritorioController = Provider.of<EscritorioController>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colores.backgroundCardColor),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(
            text: 'Ventas de los últimos 12 meses',
            textStyle: StyleTexto.styleLabelForm),
        series: <ChartSeries>[
          BarSeries<ComprasVentasModel, String>(
              animationDelay: 500,
              animationDuration: 1000,
              color: Colores.successColor,
              dataSource: escritorioController.ventasMeses,
              name: 'Ventas',
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (ComprasVentasModel ventas, _) => ventas.fecha,
              yValueMapper: (ComprasVentasModel ventas, _) => ventas.total),
        ],
      ),
    );
  }
}
