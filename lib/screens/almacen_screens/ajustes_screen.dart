import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/colores.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

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
        body: Stack(
          children: [
            BackgroundImg(),
            Padding(
              padding: const EdgeInsets.all(25),
              child: _PantallaPrincipal(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _BotonespPrincipal(),
          const SizedBox(height: 25),
          _Tabla(),
        ],
      ),
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
                label: const Text('Reporte',
                    style: TextStyle(color: Colors.white)),
                style: StyleTexto.getButtonStyle(Colors.blue.shade500),
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
                label: const Text('PDF', style: TextStyle(color: Colors.white)),
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
    return Container(
      decoration: StyleTexto.boxDecorationCard,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15), //esquinas fondo tabla
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
    );
  }

  List<TableRow> _crearTabla(BuildContext context, List<AjusteModel> ajustes) {
    List<TableRow> celdas = [];

    final format = DateFormat("yyyy-MM-dd HH:mm:ss");
    const textColumStyle = TextStyle(color: Colors.white, fontSize: 16);

    List<AjusteModel> ajustes = List.generate(
      3,
      (index) => AjusteModel(
        articulo: ArticuloAjuste(
            idArticulo: 'idArticulo', nombreArticulo: 'nombreArticulo'),
        descripcion: 'descripcion',
        idAjuste: 'idAjuste',
        precioVenta: 180.2,
        stock: 5.0,
        usuario: UsuarioAjuste(idUsuario: 'idUsuario', nombre: 'nombre'),
        fecha: Timestamp.fromDate(DateTime.now()),
      ),
    );

    final boxDecoration = BoxDecoration(
      color: Colores.secondaryColor,
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(15),
    );

    const boxDecorationCell = BoxDecoration(
      border: Border(
        left: BorderSide(color: Colors.black54),
        right: BorderSide(color: Colors.black54),
      ),
    );

    const boxDecorationCellRigth = BoxDecoration(
      border: Border(
        right: BorderSide(color: Colors.black54),
      ),
    );

    const boxConstrainst = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(decoration: boxDecoration, children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20), //ancho de la celda
            child: const Center(
              child: Text('Nombre Articulo', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: Text('Nombre Usuario', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: Text('Descripcion', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: Text('Stock', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCellRigth,
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: Text('Precio Venta', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: Text('Fecha', style: textColumStyle),
            ),
          ),
        ),
      ]),
    );

    for (int i = 0; i < ajustes.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 2 != 0 ? Colors.white12 : Colors.white12,
        borderRadius: i % 1 != 0 ? BorderRadius.circular(25) : null,
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
