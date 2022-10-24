import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/screens/screens.dart';
import 'package:puntos_ventas_tt/utils/colores.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
import 'package:puntos_ventas_tt/widgets/app_bar.dart';

class AjustesScreen extends StatelessWidget {
  static String routePage = 'AjustesScreen';
  const AjustesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: Appbar.AppbarStyle(title: 'Ajustes'),
        drawer: DrawerMenu(routeActual: routePage),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: _PantallaPrincipal(),
        ),
      ),
    );
  }
}

class _PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BotonespPrincipal(),
        const SizedBox(height: 25),
        _Tabla(),
      ],
    );
  }
}

class _BotonespPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ajusteController = Provider.of<AjusteController>(context);
    AjusteFormController formController = AjusteFormController();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.description_outlined,
                    color: Colores.textColorButton),
                label: Text('Reporte', style: StyleTexto.styleTextbutton),
                style: StyleTexto.getButtonStyle(Colores.secondaryColor),
                onPressed: () => ajusteController.getReporte(),
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.save_outlined, color: Colores.textColorButton),
                label: Text('PDF', style: StyleTexto.styleTextbutton),
                style: StyleTexto.getButtonStyle(Colores.dangerColor),
                onPressed: () {
                  ajusteController.getReporte(buscar: true);
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: TextField(
                controller: formController.buscar,
                decoration: InputDecoration(
                    suffixIcon: ajusteController.buscarVacio
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () {
                              ajusteController.buscarVacio = true;
                              FocusScope.of(context).unfocus();
                            },
                          ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Buscar',
                    labelText: 'Buscar'),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  if (value == '') {
                    ajusteController.buscarVacio = true;
                  } else {
                    ajusteController.buscarVacio = false;
                    ajusteController.buscarAjustes();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Tabla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ajustesController = Provider.of<AjusteController>(context);
    return Expanded(
      child: Container(
        decoration: StyleTexto.boxDecorationCard,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: _crearTabla(
                    context,
                    ajustesController.buscarVacio == true
                        ? ajustesController.ajustes
                        : ajustesController.ajustesBuscar),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(BuildContext context, List<AjusteModel> ajustes) {
    List<TableRow> celdas = [];

    final format = DateFormat("yyyy-MM-dd HH:mm:ss");
    final textColumStyle = TextStyle(color: Colores.textColorButton);

    final boxDecoration = BoxDecoration(
      color: Colores.secondaryColor,
      border: Border.all(color: Colors.black45),
      borderRadius: BorderRadius.circular(25),
    );

    const boxDecorationCell = BoxDecoration(
      border: Border(
        left: BorderSide(color: Colors.black45),
        right: BorderSide(color: Colors.black45),
      ),
    );

    const boxDecorationCellRigth = BoxDecoration(
      border: Border(
        right: BorderSide(color: Colors.black45),
      ),
    );

    const boxConstrainst = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(decoration: boxDecoration, children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Nombre Articulo', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Nombre Usuario', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Descripcion', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Stock', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCellRigth,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Precio Venta', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Fecha', style: textColumStyle),
            ),
          ),
        ),
      ]),
    );

    for (int i = 0; i < ajustes.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 2 != 0 ? Colores.backgroundCardColor : Colors.white,
        borderRadius: i % 2 != 0 ? BorderRadius.circular(25) : null,
      );
      celdas.add(
        TableRow(decoration: boxDecorationCellConten, children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(ajustes[i].articulo.nombreArticulo),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(ajustes[i].usuario.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(ajustes[i].descripcion),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('${ajustes[i].stock}'),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('${ajustes[i].precioVenta}'),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(format.format(ajustes[i].fecha.toDate())),
              ),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }
}
