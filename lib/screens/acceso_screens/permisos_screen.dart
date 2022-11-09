import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class PermisosScreen extends StatelessWidget {
  static String routePage = 'PermisosScreen';
  const PermisosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: Appbar.AppbarStyle(title: 'Permisos'),
        drawer: DrawerMenu(routeActual: routePage),
        body: Stack(children: [
          BackgroundImg(),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TablaPermisos(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _TablaPermisos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: StyleTexto.boxDecorationCard,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: _crearTabla(context),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(BuildContext context) {
    List<TableRow> celdas = [];

    final textColumStyle =
        TextStyle(color: Colores.textColorButton, fontSize: 16);

    final boxDecoration = BoxDecoration(
      color: Colores.secondaryColor,
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(15),
    );

    const boxConstraints = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(decoration: boxDecoration, children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Permisos', style: textColumStyle),
            ),
          ),
        ),
      ]),
    );

    List<String> permisos = [
      'Escritorio',
      'Almacen',
      'Compras',
      'Ventas',
      'Acceso',
      'Consulta Compras',
      'Consulta Ventas'
    ];

    for (var i = 0; i < permisos.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 2 != 0 ? Colors.white10 : Colors.white10,
        borderRadius: i % 1 != 0 ? BorderRadius.circular(15) : null,
      );

      celdas.add(
        TableRow(decoration: boxDecorationCellConten, children: [
          TableCell(
            child: Container(
              width: double.infinity,
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(permisos[i]),
              ),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }
}
