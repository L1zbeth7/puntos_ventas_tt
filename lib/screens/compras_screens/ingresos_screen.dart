import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/colores.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class IngresosScreen extends StatelessWidget {
  static String routePage = 'IngresosScreen';
  const IngresosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ingresoController = Provider.of<IngresosController>(context);
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: Appbar.AppbarStyle(title: 'Ingresos'),
        drawer: DrawerMenu(routeActual: routePage),
        body: Stack(children: [
          BackgroundImg(),
          Padding(
            padding: const EdgeInsets.all(25),
            child: ingresoController.pantallaActiva == 0
                ? _PantallaPrincipal()
                : _PantallaFormulario(),
          ),
        ]),
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
    final ingresoController = Provider.of<IngresosController>(context);
    IngresoFormController formController = IngresoFormController();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.add, color: Colores.textColorButton),
                label: Text('Agregar', style: StyleTexto.styleTextbutton),
                style: StyleTexto.getButtonStyle(Colores.successColor),
                onPressed: () async {
                  ingresoController.pantallaActiva = 1;
                  ingresoController.limpiarFormulario();
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.description_outlined,
                    color: Colores.textColorButton),
                label: Text('Reporte', style: StyleTexto.styleTextbutton),
                style: StyleTexto.getButtonStyle(Colors.blue.shade600),
                onPressed: () {
                  ingresoController.getReporte();
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
                  ingresoController.getReporte(buscar: true);
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: TextFormField(
                controller: formController.buscar,
                decoration: InputDecoration(
                    suffixIcon: ingresoController.buscarVacio
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () {
                              ingresoController.buscarVacio = true;
                              FocusScope.of(context).unfocus();
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Buscar',
                    labelText: 'Buscar'),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    ingresoController.buscarVacio = true;
                  } else {
                    ingresoController.buscarVacio = false;
                    ingresoController.buscarIngreso();
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
    final ingresoController = Provider.of<IngresosController>(context);
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
                  ingresoController.buscarVacio == true
                      ? ingresoController.ingresos
                      : ingresoController.ingresosBuscar),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(BuildContext context, List<IngresoModel> ingreso) {
    final format = DateFormat("yyyy-MM-dd hh:mm:ss");
    List<TableRow> celdas = [];

    final textColumStyle =
        TextStyle(color: Colores.textColorButton, fontSize: 16);

    List<IngresoModel> ingreso = List.generate(
      4,
      (index) => IngresoModel(
          proveedor:
              ProveedorModel(idCliente: 'sfklgjlridk', nombre: 'Pollito'),
          fecha: Timestamp.fromDate(DateTime.now()),
          impuesto: 25.5,
          serieComprobante: 'serieN',
          detalle: [
            ArticuloVentaModel(
                idArticulo: 'idArticulo',
                articulo: 'articulo',
                codigo: 'codigo',
                cantidad: 5.8,
                precioVenta: 89.7,
                descuento: 2.5,
                subtotal: 759.3)
          ],
          totalIngreso: 1589.67,
          numeroComprobante: 'numeroX',
          tipoComprobante: 'ticket',
          activo: true,
          idVenta: 'yrsggj',
          usuario: UsuarioVentaModel(idUsuario: 'idUsuario', nombre: 'nombre'),
          sucursal:
              SucursalVentaModel(idSucursal: 'idSucursal', nombre: 'nombre')),
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

    const boxConstrainst = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(decoration: boxDecoration, children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Opciones', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Fecha', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Cliente', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Usuario', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Documento', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Numero', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Total Venta', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Sucursal', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Estado', style: textColumStyle),
            ),
          ),
        ),
      ]),
    );

    for (int i = 0; i < ingreso.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 2 != 0 ? Colors.white12 : Colors.white12,
        borderRadius: i % 1 != 0 ? BorderRadius.circular(25) : null,
      );

      celdas.add(
        TableRow(decoration: boxDecorationCellConten, children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Row(
                  children: [
                    if (ingreso[i].activo)
                      _botonCancelar(context, ingreso[i].idVenta)
                  ],
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  format.format(ingreso[i].fecha.toDate()),
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(child: Text(ingreso[i].proveedor.nombre)),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(child: Text(ingreso[i].usuario.nombre)),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(child: Text(ingreso[i].tipoComprobante)),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Text(
                      '${ingreso[i].serieComprobante}-${ingreso[i].numeroComprobante}')),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(child: Text('${ingreso[i].totalIngreso}')),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(child: Text(ingreso[i].sucursal.nombre)),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainst,
              padding: const EdgeInsets.all(20),
              child: Center(child: _etiquetaActivo(ingreso[i].activo)),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }

  _botonCancelar(BuildContext context, String idVenta) {
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(roundedRectangleBorder),
        backgroundColor: MaterialStateProperty.all(Colors.redAccent),
      ),
      child: const Icon(Icons.block_flipped, color: Colors.white),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: roundedRectangleBorder,
              title: const Text('Alerta'),
              content: const Text('Seguro de cancelar el ingreso registrado?'),
              actions: [
                _cancelButton(context),
                _okButton(context, idVenta),
              ],
            );
          },
        );
      },
    );
  }

  _cancelButton(BuildContext context) => TextButton(
      child: const Text('Cancelar'), onPressed: () => Navigator.pop(context));

  _okButton(BuildContext context, String idVenta) {
    final ingresoController = Provider.of<IngresosController>(context);
    return TextButton(
      child: const Text('Ok'),
      onPressed: () {
        ingresoController.cancelarIngreso(idVenta);
        Navigator.pop(context);
      },
    );
  }

  _etiquetaActivo(bool valor) {
    return Container(
      decoration: BoxDecoration(
          color: valor ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.all(10),
      child: Text(
        valor ? 'Aceptado' : 'Cancelado',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class _PantallaFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: StyleTexto.boxDecorationCard,
                margin: const EdgeInsets.all(10),
                child: _IngresoCard(),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: StyleTexto.boxDecorationCard,
                margin: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: _Formulario(),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: StyleTexto.boxDecorationCard,
                margin: const EdgeInsets.only(
                    bottom: 60, left: 10, right: 10, top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: const SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    //child: _TablaArticulosMuestra(), -> hace que la tabla este afuera
                  ),
                ),
              ),
            ],
          ),
        ),
        _BotonesFormulario(),
      ],
    );
  }
}

class _IngresoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    IngresoFormController formController = IngresoFormController();

    FocusNode focoSerie = FocusNode();
    FocusNode numeroComprobante = FocusNode();

    return Form(
      key: formController.formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text('Ingreso', style: StyleTexto.styleTextSubtitle),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _BropDownProveedores(),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: TextFormField(
                    controller: formController.fecha,
                    enabled: false,
                    decoration: StyleTexto.getInputStyle('Fecha'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _BropDownTipoComprobante(),
                ),
                const SizedBox(width: 15),
                Flexible(
                  flex: 2,
                  child: TextFormField(
                    controller: formController.serie,
                    textCapitalization: TextCapitalization.words,
                    decoration: StyleTexto.getInputStyle('Serie Comprobante'),
                    focusNode: focoSerie,
                    validator: (value) {
                      if (value!.isEmpty) {
                        FocusScope.of(context).requestFocus(focoSerie);
                        return 'Ingresa una serie';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: formController.nVenta,
                    decoration:
                        StyleTexto.getInputStyle('Número de comprobante'),
                    focusNode: numeroComprobante,
                    validator: (value) {
                      if (value!.isEmpty) {
                        FocusScope.of(context).requestFocus(numeroComprobante);
                        return 'Ingresa un número de comprobante';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: TextFormField(
                    controller: formController.impuesto,
                    keyboardType: TextInputType.number,
                    decoration: StyleTexto.getInputStyle('Impuesto'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,3}'))
                    ],
                    validator: (value) {
                      if (value == '') return 'Ingresa un valor';
                      double numero = double.parse(value!);
                      if (numero < 0) {
                        return 'No pueden ingresar numeros negativos';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              decoration: StyleTexto.boxDecorationCard,
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: _TablaArticulosMuestra(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BropDownProveedores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ingresoController = Provider.of<IngresosController>(context);
    IngresoFormController formController = IngresoFormController();

    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      focusColor: Colors.green,
      value: ingresoController.proveedorSelect,
      decoration: StyleTexto.getInputStyle('Proveedores'),
      items: getItemsProveedores(context),
      isExpanded: true,
      onChanged: (value) {
        ingresoController.proveedorSelect = value!;
        formController.proveedorSeleccionado = value;
      },
    );
  }

  List<DropdownMenuItem<String>> getItemsProveedores(BuildContext context) {
    final ingresoController =
        Provider.of<IngresosController>(context, listen: false);
    List<DropdownMenuItem<String>> items = [];

    for (var element in ingresoController.proveedoresActivos) {
      items.add(
        DropdownMenuItem(
          value: element.id,
          child: Text(element.nombre),
        ),
      );
    }
    return items;
  }
}

class _BropDownTipoComprobante extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ingresoController = Provider.of<IngresosController>(context);
    IngresoFormController formController = IngresoFormController();

    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.green,
      value: ingresoController.comprobante,
      decoration: StyleTexto.getInputStyle('Comprobante'),
      items: getItemsComprobante(context),
      isExpanded: true,
      onChanged: (value) {
        ingresoController.comprobante = value!;
        formController.comprobante = value;
      },
    );
  }

  List<DropdownMenuItem<String>> getItemsComprobante(BuildContext context) {
    List<DropdownMenuItem<String>> items = [];

    items.add(
      const DropdownMenuItem(
        value: 'Ticket',
        child: Text('Ticket'),
      ),
    );
    items.add(
      const DropdownMenuItem(
        value: 'Boleta',
        child: Text('Boleta'),
      ),
    );
    items.add(
      const DropdownMenuItem(
        value: 'Factura',
        child: Text('Factura'),
      ),
    );
    return items;
  }
}

class _Formulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    IngresoFormController formController = IngresoFormController();
    return Form(
      key: formController.formKeyIngreso,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            // decoration: BoxDecoration(
            //   color: Colores.secondaryColor,
            // ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('Cuenta', style: StyleTexto.styleTextSubtitle),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: formController.cantidad,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: StyleTexto.getInputStyle('Cantidad'),
                        textCapitalization: TextCapitalization.words,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,3}'))
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextButton(
                        style: StyleTexto.getButtonStyle(Colores.successColor),
                        onPressed: () {
                          _escanerCamara(context);
                        },
                        child: Icon(Icons.camera_alt_outlined,
                            color: Colores.textColorButton),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child:
                            Text('Total:', style: StyleTexto.styleTextSubtitle),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: TextFormField(
                        controller: formController.totalCuenta,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: StyleTexto.getInputStyle('Total'),
                        textCapitalization: TextCapitalization.sentences,
                        enabled: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: StyleTexto.boxDecorationCard,
                  margin: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: _TablaArticulosIngreso(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _escanerCamara(BuildContext context) async {
    IngresoFormController formController = IngresoFormController();
    final ingresoController =
        Provider.of<IngresosController>(context, listen: false);
    String barcodeScanres = await FlutterBarcodeScanner.scanBarcode(
        '#3d8BEF', 'Cancelar', false, ScanMode.BARCODE);

    FocusManager.instance.primaryFocus!.unfocus();

    if (barcodeScanres == '-1') {
      const CustomToast(mensaje: 'No se escaneo articulo').showToast(context);
    } else {
      for (int i = 0; i < ingresoController.articulosActivos.length; i++) {
        if (barcodeScanres == ingresoController.articulosActivos[i].codigo) {
          ingresoController
              .addArticuloIngreso(ingresoController.articulosActivos[i].copy());
          formController.cantidad.text = '1';

          ingresoController.calcularTotales();

          return;
        }
      }
      const CustomToast(mensaje: 'No se encontro articulo').showToast(context);
    }
  }
}

class _TablaArticulosIngreso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ingresoController = Provider.of<IngresosController>(context);
    return Form(
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: _crearTabla(context, ingresoController.articulosIngreso),
      ),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<ArticuloModel> articulos) {
    final ingresoController = Provider.of<IngresosController>(context);

    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    // List<ArticuloModel> articulos = List.generate(
    //     2,
    //     (index) => ArticuloModel(
    //         activo: true,
    //         categoria: CategoriaModel(
    //             activo: true,
    //             descripcion: 'descripcion',
    //             idCategoria: 'idCategoria',
    //             nombre: 'nombre',
    //             porcentaje: 2),
    //         descripcion: 'descripcion',
    //         nombre: 'nombre',
    //         codigo: 'codigo',
    //         idArticulo: 'idArticulo',
    //         imagen: '',
    //         precioVenta: 180.9,
    //         stock: 18.4));

    final boxDecoration = BoxDecoration(
      color: Colores.secondaryColor,
      border: Border.all(color: Colors.black45),
      borderRadius: BorderRadius.circular(15),
    );

    const boxDecorationCell = BoxDecoration(
      border: Border(
          left: BorderSide(color: Colors.black45),
          right: BorderSide(color: Colors.black45)),
    );

    const boxDecorationCellLeft = BoxDecoration(
      border: Border(
        left: BorderSide(color: Colors.black45),
      ),
    );

    const boxConstraints = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(
        decoration: boxDecoration,
        children: [
          TableCell(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Opciones', style: textColumStyle),
              ),
            ),
          ),
          TableCell(
            child: Container(
              decoration: boxDecorationCell,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Nombre', style: textColumStyle),
              ),
            ),
          ),
          TableCell(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Cantidad', style: textColumStyle),
              ),
            ),
          ),
          TableCell(
            child: Container(
              decoration: boxDecorationCell,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Precio Compra', style: textColumStyle),
              ),
            ),
          ),
          TableCell(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Descuento', style: textColumStyle),
              ),
            ),
          ),
          TableCell(
            child: Container(
              decoration: boxDecorationCell,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Porcentaje', style: textColumStyle),
              ),
            ),
          ),
          TableCell(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Precio Venta Suguerido', style: textColumStyle),
              ),
            ),
          ),
          TableCell(
            child: Container(
              decoration: boxDecorationCellLeft,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Subtotal', style: textColumStyle),
              ),
            ),
          ),
        ],
      ),
    );

    for (int i = 0; i < articulos.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 2 != 0 ? Colors.white12 : Colors.white12,
        borderRadius: i % 1 != 0 ? BorderRadius.circular(25) : null,
      );
      celdas.add(
        TableRow(decoration: boxDecorationCellConten, children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _botonQuitar(context, articulos[i]),
                    if (articulos[i].categoria.nombre == 'Agranel')
                      const SizedBox(width: 15),
                    if (articulos[i].categoria.nombre == 'Agranel')
                      _botonCalcular(context, i)
                  ],
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: TextFormField(
                  controller:
                      ingresoController.articulosFormIngreso[i].cantidad,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Cantidad'),
                  onChanged: (value) {
                    ingresoController.calcularTotales();
                  },
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: TextFormField(
                  controller:
                      ingresoController.articulosFormIngreso[i].precioCompra,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Precio Compra'),
                  onChanged: (value) {
                    ingresoController.calcularTotales();
                  },
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: TextFormField(
                  controller:
                      ingresoController.articulosFormIngreso[i].descuento,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Descuento'),
                  onChanged: (value) {
                    ingresoController.calcularTotales();
                  },
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: TextFormField(
                  controller:
                      ingresoController.articulosFormIngreso[i].porcentaje,
                  enabled: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Porcentaje'),
                  onChanged: (value) {
                    ingresoController.calcularTotales();
                  },
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: TextFormField(
                  controller:
                      ingresoController.articulosFormIngreso[i].precioVenta,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Precio Venta'),
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: TextFormField(
                  enabled: false,
                  controller:
                      ingresoController.articulosFormIngreso[i].subtotal,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Subtotal'),
                ),
              ),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }

  _botonQuitar(BuildContext context, ArticuloModel articulo) {
    final ingresoController =
        Provider.of<IngresosController>(context, listen: false);

    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colores.dangerColor)),
      child: const Icon(Icons.delete, color: Colors.white),
      onPressed: () {
        ingresoController.quitarArticuloIngreso(articulo.idArticulo);
      },
    );
  }

  _botonCalcular(BuildContext context, int index) {
    var roundedRactangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));
    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)))),
      child: const Icon(Icons.calculate_rounded, color: Colors.white),
      onPressed: () {
        final ingresoController =
            Provider.of<IngresosController>(context, listen: false);

        TextEditingController cantidad1 = TextEditingController(text: '1');
        TextEditingController precio1 = TextEditingController(
          text: ingresoController.articulosFormIngreso[index].precioVenta.text
              .toString(),
        );
        TextEditingController cantidad2 = TextEditingController(text: '1');
        TextEditingController precio2 = TextEditingController(
          text: ingresoController.articulosFormIngreso[index].precioVenta.text
              .toString(),
        );

        showDialog(
          context: context,
          builder: (_) {
            return SimpleDialog(
              shape: roundedRactangleBorder,
              title: const Text('Calculadora de precios'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      TextField(
                        controller: cantidad1,
                        keyboardType: TextInputType.number,
                        enabled: false,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,3}'))
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: 'Cantida',
                            labelText: 'Cantidad'),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: precio1,
                        keyboardType: TextInputType.number,
                        enabled: false,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,3}'))
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: 'Precio',
                            labelText: 'Precio'),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: cantidad2,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,3}'))
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: 'Cantidad',
                            labelText: 'Cantidad'),
                        onChanged: (value) {
                          if (cantidad2.text != '') {
                            double cantidadArticulo =
                                double.parse(value.toString());
                            double precioArticulo = double.parse(precio1.text);
                            precio2.text = (cantidadArticulo * precioArticulo)
                                .toStringAsFixed(3);
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: precio2,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,3}'))
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: 'Precio',
                            labelText: 'Precio'),
                        onChanged: (value) {
                          if (precio2.text != '') {
                            double precioArticulo = double.parse(precio1.text);
                            cantidad2.text = (double.parse(value.toString()) /
                                    precioArticulo)
                                .toStringAsFixed(3);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _okButtonCalculate(context, index, cantidad2),
                    const SizedBox(width: 10),
                    _cancelButtonCalculate(context),
                    const SizedBox(width: 15),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  _okButtonCalculate(
      BuildContext context, int index, TextEditingController cantidad) {
    final ingresoController =
        Provider.of<IngresosController>(context, listen: false);

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
          backgroundColor: MaterialStateProperty.all(Colors.green)),
      onPressed: () {
        (cantidad.text == '')
            ? ingresoController.articulosFormIngreso[index].cantidad.text = '0'
            : ingresoController.articulosFormIngreso[index].cantidad.text =
                cantidad.text.toString();
        ingresoController.calcularTotales();
        Navigator.pop(context);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text('Agregar cantidad', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  _cancelButtonCalculate(BuildContext context) => TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100))),
            backgroundColor: MaterialStateProperty.all(Colors.red)),
        onPressed: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text('Cancelar', style: TextStyle(color: Colors.white)),
        ),
      );
}

class _TablaArticulosMuestra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ingresoController = Provider.of<IngresosController>(context);
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: _crearTabla(context, ingresoController.articulosActivos),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<ArticuloModel> articulos) {
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    List<ArticuloModel> articulos = List.generate(
        2,
        (index) => ArticuloModel(
            activo: true,
            categoria: CategoriaModel(
                activo: true,
                descripcion: 'descripcion',
                idCategoria: 'idCategoria',
                nombre: 'nombre',
                porcentaje: 2),
            descripcion: 'descripcion',
            nombre: 'nombre',
            codigo: 'codigo',
            idArticulo: 'idArticulo',
            imagen: '',
            precioVenta: 68.3,
            stock: 8.6));

    final boxDecoration = BoxDecoration(
      color: Colores.secondaryColor,
      border: Border.all(color: Colors.black45),
      borderRadius: BorderRadius.circular(15),
    );

    const boxDecorationCell = BoxDecoration(
      border: Border(
        left: BorderSide(color: Colors.black45),
        right: BorderSide(color: Colors.black45),
      ),
    );

    const boxConstraints = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(decoration: boxDecoration, children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Opciones', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Nombre', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Categoria', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Descripcion', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Codigo', style: textColumStyle),
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
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Precio Venta', style: textColumStyle),
            ),
          ),
        ),
      ]),
    );

    for (int i = 0; i < articulos.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 2 != 0 ? Colors.white12 : Colors.white12,
        borderRadius: i % 1 != 0 ? BorderRadius.circular(25) : null,
      );
      celdas.add(
        TableRow(decoration: boxDecorationCellConten, children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Row(
                  children: [_botonAgregar(context, articulos[i])],
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].categoria.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].descripcion),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].codigo),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('${articulos[i].stock}'),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('${articulos[i].precioVenta}'),
              ),
            ),
          ),
        ]),
      );
    }

    return celdas;
  }

  _botonAgregar(BuildContext context, ArticuloModel articulo) {
    final ingresoController =
        Provider.of<IngresosController>(context, listen: false);

    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colores.warningColor)),
      onPressed: () {
        ingresoController.addArticuloIngreso(articulo);
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

class _BotonesFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ingresoController = Provider.of<IngresosController>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.description_outlined,
                  color: Colores.textColorButton, size: 28),
              label:
                  Text('Reporte Ingresos', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(Colors.green.shade600),
              onPressed: () {
                ingresoController.pantallaActiva = 0;
                ingresoController.getIngresos();
              },
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.request_quote_outlined,
                  color: Colores.textColorButton, size: 28),
              label:
                  Text('Registrar Ingreso', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(Colors.blue.shade600),
              onPressed: () {
                FocusManager.instance.primaryFocus!.unfocus();
                var reundedRactangleBorder = const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)));
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      shape: reundedRactangleBorder,
                      title: const Text('Alerta'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                              'Recuerda verificar el nuevo precio de los productos ingresados'),
                          Text(
                              '¿Quieres registrar y actualizar los productos agregados?')
                        ],
                      ),
                      actions: [_cencelButton(context), _okButton(context)],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _cencelButton(BuildContext context) => TextButton(
        child: const Text('Cancelar'),
        onPressed: () => Navigator.pop(context),
      );

  _okButton(BuildContext context) {
    final ingresoController =
        Provider.of<IngresosController>(context, listen: false);
    IngresoFormController formController = IngresoFormController();

    return TextButton(
      child: const Text('Ok'),
      onPressed: () {
        if (formController.isValidForm && formController.isValidFormVenta) {
          if (ingresoController.articulosIngreso.isEmpty) {
            const CustomToast(mensaje: 'Ingresa al menos un producto')
                .showToast(context);
            Navigator.pop(context);
          } else {
            ingresoController.registrarIngreso().then(
              (value) {
                ingresoController.pantallaActiva = 0;
                ingresoController.getIngresos();
              },
            );
            Navigator.pop(context);
          }
        }
      },
    );
  }
}
