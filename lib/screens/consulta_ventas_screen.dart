import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/consulta_ventas_controller.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/colores.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class ConsultaVentasScreen extends StatelessWidget {
  static String routePage = 'ConsultaVentasScreen';
  const ConsultaVentasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar.AppbarStyle(title: 'Consulta Ventas'),
      drawer: DrawerMenu(routeActual: routePage),
      body: Stack(children: [
        BackgroundImg(),
        Padding(
          padding: const EdgeInsets.all(25),
          child: _PantallaPrincipal(),
        ),
      ]),
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
          _TablaCategorias(),
        ],
      ),
    );
  }
}

class _BotonespPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final consultaController = Provider.of<ConsultaVentasController>(context);
    final format = DateFormat("yyyy-MM-dd");

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: DateTimeField(
                format: format,
                controller: consultaController.fechaInicio,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Fecha Inicio',
                    labelText: 'Fecha Inicio'),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                    context: context,
                    locale: const Locale("es"),
                    initialDate: consultaController.fechaInicial,
                    firstDate: DateTime(2000),
                    lastDate: consultaController.fechaFinal,
                  );
                  if (date != null) {
                    consultaController.fechaInicial = date;
                    return date;
                  } else {
                    consultaController.fechaInicial = DateTime.now();
                    return consultaController.fechaInicial;
                  }
                },
                onChanged: (value) {
                  consultaController.fechaInicio.text = format.format(value!);
                  consultaController.getCompras();
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: DateTimeField(
                format: format,
                controller: consultaController.fechaFin,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Fecha Fin',
                    labelText: 'Fecha Fin'),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                    context: context,
                    locale: const Locale("es"),
                    initialDate: consultaController.fechaInicial,
                    firstDate: consultaController.fechaInicial,
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    consultaController.fechaFinal = date;
                    return date;
                  } else {
                    consultaController.fechaFinal = DateTime.now();
                    return consultaController.fechaFinal;
                  }
                },
                onChanged: (value) {
                  consultaController.fechaFin.text = format.format(value!);
                  consultaController.getCompras();
                },
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.picture_as_pdf_outlined,
                    color: Colores.textColorButton),
                label: Text('PDF', style: StyleTexto.styleTextbutton),
                style: StyleTexto.getButtonStyle(Colores.dangerColor),
                onPressed: () {
                  consultaController.buscarVacio
                      ? consultaController.getReporte()
                      : consultaController.getReporte(buscar: true);
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: TextField(
                controller: consultaController.buscar,
                decoration: InputDecoration(
                    suffixIcon: consultaController.buscarVacio
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () {
                              consultaController.buscarVacio = true;
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
                  if (value.isEmpty) {
                    consultaController.buscarVacio = true;
                  } else {
                    consultaController.buscarVacio = false;
                    consultaController.buscarIngreso();
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

class _TablaCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final consultaController = Provider.of<ConsultaVentasController>(context);

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
              children: _crearTabla(
                  context,
                  consultaController.buscarVacio == true
                      ? consultaController.ingresos
                      : consultaController.ingresosBuscar),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(BuildContext context, List<VentaModelV> ingresos) {
    final format = DateFormat("yyyy-MM-dd hh:mm:ss");
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    List<VentaModelV> ingresos = List.generate(
      2,
      (index) => VentaModelV(
        cliente: ClienteVentaModel(
            idCliente: 'idCliente',
            nombre: 'nombreCliente',
            direccion: 'direccion',
            telefono: '123456789',
            email: 'email@gmail.com'),
        fecha: Timestamp.fromDate(DateTime.now()),
        impuesto: 12.8,
        serieComprobante: 'serieComprobante',
        detalle: [
          ArticuloVentaModel(
              idArticulo: 'idArticulo',
              articulo: 'articulo',
              codigo: 'codigo',
              cantidad: 14.1,
              precioVenta: 26.4,
              descuento: 0.5,
              subtotal: 879.2)
        ],
        totalVenta: 1500.98,
        numeroComprobante: 'numeroComprobante',
        tipoComprobante: 'tipoComprobante',
        activo: true,
        idVenta: 'idVenta',
        usuario:
            UsuarioVentaModel(idUsuario: 'idUsuario', nombre: 'nombreUsuario'),
        sucursal: SucursalVentaModel(
            idSucursal: 'idSucursal', nombre: 'nombreSucursal'),
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
          right: BorderSide(color: Colors.black54)),
    );

    const boxDecorationCellLeft = BoxDecoration(
      border: Border(left: BorderSide(color: Colors.black54)),
    );

    const boxConstraints = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(decoration: boxDecoration, children: [
        TableCell(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Fecha', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Cliente', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Usuario', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Documento', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Número Documento', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Total Venta', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Sucursal', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCellLeft,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Estado', style: textColumStyle),
            ),
          ),
        ),
      ]),
    );

    for (int i = 0; i < ingresos.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
          color: i % 2 != 0 ? Colors.white10 : Colors.white10,
          borderRadius: i % 1 != 0 ? BorderRadius.circular(25) : null);
      celdas.add(
        TableRow(decoration: boxDecorationCellConten, children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(format.format(ingresos[i].fecha.toDate())),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(ingresos[i].cliente.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(ingresos[i].usuario.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(ingresos[i].tipoComprobante),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                    '${ingresos[i].serieComprobante}-${ingresos[i].numeroComprobante}'),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('${ingresos[i].totalVenta}'),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(ingresos[i].sucursal.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: _etiquetaActivo(ingresos[i].activo),
              ),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }

  _etiquetaActivo(bool valor) {
    return Container(
      decoration: BoxDecoration(
          color: valor ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.all(10),
      child: Text(
        valor ? 'Activado' : 'Desactivado',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
