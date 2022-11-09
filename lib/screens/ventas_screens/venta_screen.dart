import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class VentaScreen extends StatelessWidget {
  static String routePage = 'VentaScreen';
  const VentaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ventasControlle = Provider.of<VentaController>(context);

    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: Appbar.AppbarStyle(title: 'Ventas'),
        drawer: DrawerMenu(routeActual: routePage),
        body: Stack(
          children: [
            BackgroundImg(),
            Padding(
              padding: const EdgeInsets.all(25),
              child: ventasControlle.pantallaActiva == 0
                  ? _PantallaPrincipal()
                  : _PantallaFormulario(),
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
    final ventasController = Provider.of<VentaController>(context);
    VentasFormController formController = VentasFormController();

    return Column(
      children: [
        Row(children: [
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.add, color: Colores.textColorButton),
              label: Text('Agregar', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(Colores.successColor),
              onPressed: () async {
                final format = DateFormat("yyyy-MM-dd");
                formController.fecha.text = format.format(DateTime.now());

                UserPreferencesSecure userPreferences = UserPreferencesSecure();
                String nombreTienda = await userPreferences.getNombreTienda();
                String nombreSucursal =
                    await userPreferences.getNombreSucursal();

                // formController.serie.text =
                //     '${nombreTienda.substring(0, 3)}${nombreTienda.substring(nombreTienda.length - 1)}-${nombreSucursal.substring(0, 3)}${nombreSucursal.substring(nombreSucursal.length - 1)}';
                formController.serie.text =
                    '${nombreTienda.substring(0, 3)}${nombreTienda.substring(nombreTienda.length - 1)}-${nombreSucursal.substring(0, 3)}${nombreSucursal.substring(nombreSucursal.length - 1)}';
                formController.nVenta.text =
                    (await userPreferences.getNumVenta()).toString();
                formController.comprobante = 'Ticket';
                await ventasController.getClientesActivos();
                await ventasController.getArticulosActivos();
                ventasController.pantallaActiva = 1;
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
                ventasController.getReporte();
              },
            ),
          ),
        ]),
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
                  ventasController.getReporte(buscar: true);
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: TextFormField(
                controller: formController.buscar,
                decoration: InputDecoration(
                    suffixIcon: ventasController.buscarVacio
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () {
                              ventasController.buscarVacio = true;
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
                    ventasController.buscarVacio = true;
                  } else {
                    ventasController.buscarVacio = false;
                    ventasController.buscarVenta();
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
    final ventaController = Provider.of<VentaController>(context);

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
                  ventaController.buscarVacio == true
                      ? ventaController.ventas
                      : ventaController.ventasBuscar),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(BuildContext context, List<VentaModelV> ventas) {
    final format = DateFormat("yyyy-MM-dd hh:mm:ss");
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    List<VentaModelV> ventas = List.generate(
      3,
      (index) => VentaModelV(
        cliente: ClienteVentaModel(
            idCliente: 'idCliente',
            nombre: 'nombre',
            direccion: 'direccion',
            telefono: '1234567890',
            email: 'email@gmail.com'),
        fecha: Timestamp.fromDate(DateTime.now()),
        impuesto: 55.3,
        serieComprobante: 'serieComprobante',
        detalle: [
          ArticuloVentaModel(
              idArticulo: 'idArticulo',
              articulo: 'articulo',
              codigo: 'codigo',
              cantidad: 5.2,
              precioVenta: 180.75,
              descuento: 2.5,
              subtotal: 869.1)
        ],
        totalVenta: 1548.5,
        numeroComprobante: 'numeroComprobante',
        tipoComprobante: 'tipoComprobante',
        activo: true,
        idVenta: 'idVenta',
        usuario: UsuarioVentaModel(idUsuario: 'idUsuario', nombre: 'nombre'),
        sucursal:
            SucursalVentaModel(idSucursal: 'idSucursal', nombre: 'nombre'),
      ),
    );

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
              constraints: boxConstraints,
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
        ],
      ),
    );

    for (int i = 0; i < ventas.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 2 != 0 ? Colors.white10 : Colors.white10,
        borderRadius: i % 1 != 0 ? BorderRadius.circular(25) : null,
      );
      celdas.add(
        TableRow(
          decoration: boxDecorationCellConten,
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Row(
                    children: [
                      ventas[i].activo &&
                              ventas[i].tipoComprobante == 'Devolución'
                          ? _botonCancelarDevolucion(context, ventas[i].idVenta)
                          : _botonCancelar(context, ventas[i].idVenta),
                      const SizedBox(width: 15),
                      _botonComprobante(context, ventas[i]),
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
                  child: Text(format.format(ventas[i].fecha.toDate())),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                constraints: boxConstraints,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(ventas[i].cliente.nombre),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                constraints: boxConstraints,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(ventas[i].usuario.nombre),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                constraints: boxConstraints,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(ventas[i].tipoComprobante),
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
                      '${ventas[i].serieComprobante}-${ventas[i].numeroComprobante}'),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                constraints: boxConstraints,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text('${ventas[i].totalVenta}'),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                constraints: boxConstraints,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(ventas[i].sucursal.nombre),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                constraints: boxConstraints,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: _etiquetaActivo(ventas[i].activo),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return celdas;
  }

  _botonComprobante(BuildContext context, VentaModelV venta) {
    final ventaController =
        Provider.of<VentaController>(context, listen: false);

    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colores.successColor)),
      child: const Icon(
        Icons.article_outlined,
        color: Colors.white,
      ),
      onPressed: () {
        switch (venta.tipoComprobante) {
          case 'Ticket':
            ventaController.getTicket(venta);
            break;
          case 'Botelta':
            ventaController.getBoleta(venta);
            break;
          case 'Factura':
            ventaController.getBoleta(venta);
            break;
          default:
            ventaController.getTicket(venta);
        }
      },
    );
  }

  _botonCancelar(BuildContext context, String idVenta) {
    var roundedRectangleBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)),
    );

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colors.red)),
      child: const Icon(Icons.block, color: Colors.white),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: roundedRectangleBorder,
              title: const Text('Alerta'),
              content: const Text('Seguro de cancelar la venta registrada'),
              actions: [_cancelButton(context), _okButton(context, idVenta)],
            );
          },
        );
      },
    );
  }

  _botonCancelarDevolucion(BuildContext context, String idVenta) {
    var roundedRectangleBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)),
    );

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colors.red)),
      child: const Icon(Icons.block, color: Colors.white),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: roundedRectangleBorder,
              title: const Text('Alerta'),
              content:
                  const Text('Seguro de cancelar la devolución registrada'),
              actions: [_cancelButton(context), _okButton(context, idVenta)],
            );
          },
        );
      },
    );
  }

  _cancelButton(BuildContext context) => TextButton(
        child: const Text('Cancelar'),
        onPressed: () => Navigator.pop(context),
      );

  _okButton(BuildContext context, String idVenta) {
    final ventasController =
        Provider.of<VentaController>(context, listen: false);

    return TextButton(
      child: const Text('Ok'),
      onPressed: () {
        ventasController.cancelarDevolucion(idVenta);
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
                child: _VentaCard(),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: StyleTexto.boxDecorationCard,
                margin: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _Formulario(),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: StyleTexto.boxDecorationCard,
                margin: const EdgeInsets.only(
                    bottom: 60, left: 10, right: 10, top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: _TablaArticulosMuestra(),
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

class _VentaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VentasFormController formController = VentasFormController();
    return Form(
      key: formController.formKeyVenta,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text('Venta', style: StyleTexto.styleTextSubtitle),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _BropDownClientes(),
                ),
                const SizedBox(width: 15),
                Flexible(
                  flex: 2,
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
                    enabled: false,
                    decoration: StyleTexto.getInputStyle('Serie'),
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
                    enabled: false,
                    decoration: StyleTexto.getInputStyle('Número de venta'),
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: TextFormField(
                    controller: formController.impuesto,
                    keyboardType: StyleTexto.getInputStyle('Impuesto'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,3}'))
                    ],
                    validator: ((value) {
                      if (value == '') return 'Ingresa un valor';
                      double numero = double.parse(value!);
                      if (numero < 0) {
                        return 'No ingresar números negativos';
                      }
                      return null;
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BropDownClientes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ventasController = Provider.of<VentaController>(context);
    VentasFormController formController = VentasFormController();

    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.green,
      value: ventasController.clienteSelect,
      decoration: StyleTexto.getInputStyle('Cliente'),
      items: getItemsClientes(context),
      isExpanded: true,
      onChanged: (value) {
        ventasController.clienteSelect = value!;
        formController.clienteSeleccionado = value;
      },
    );
  }

  List<DropdownMenuItem<String>> getItemsClientes(BuildContext context) {
    final ventasController =
        Provider.of<VentaController>(context, listen: false);
    List<DropdownMenuItem<String>> items = [];

    for (var element in ventasController.clientesActivos) {
      items.add(
        DropdownMenuItem(value: element.id, child: Text(element.nombre)),
      );
    }
    return items;
  }
}

class _BropDownTipoComprobante extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ventasController = Provider.of<VentaController>(context);
    VentasFormController formController = VentasFormController();

    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      focusColor: Colors.green,
      value: ventasController.comprobante,
      decoration: StyleTexto.getInputStyle('Comprobante'),
      items: getItemsComprobante(context),
      isExpanded: true,
      onChanged: (value) {
        ventasController.comprobante = value!;
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
    final ventasController = Provider.of<VentaController>(context);
    VentasFormController formController = VentasFormController();

    return Form(
      key: formController.formKey,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colores.secondaryColor,
            ),
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
                            Text('Total', style: StyleTexto.styleTextSubtitle),
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
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child:
                            Text('Recibe', style: StyleTexto.styleTextSubtitle),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: TextFormField(
                        controller: formController.recibe,
                        decoration: StyleTexto.getInputStyle('Recibe'),
                        textCapitalization: TextCapitalization.sentences,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,3}'))
                        ],
                        validator: (value) {
                          if (value == '') return 'Ingresa un número mayor a 0';
                          double recibe = double.parse(value!);
                          if (recibe <= 0) {
                            return 'Ingresa un número mayor a 0';
                          }
                          double total =
                              double.parse(formController.totalCuenta.text);
                          if (recibe < total) {
                            return 'El número debe ser mayor o igual al total';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          ventasController.calcularTotales();
                        },
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
                            Text('Cambio', style: StyleTexto.styleTextSubtitle),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: TextFormField(
                        controller: formController.cambio,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: StyleTexto.getInputStyle('Cambio'),
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
                    borderRadius: BorderRadius.circular(25),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: _TablaArticulosVenta(),
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
    VentasFormController formController = VentasFormController();
    final ventaController =
        Provider.of<VentaController>(context, listen: false);

    String barcodeScanres = await FlutterBarcodeScanner.scanBarcode(
        '#3d8BEF', 'Cancelar', false, ScanMode.BARCODE);
    FocusManager.instance.primaryFocus!.unfocus();

    if (barcodeScanres == '-1') {
      const CustomToast(mensaje: 'No se escaneo articulo').showToast(context);
    } else {
      for (int i = 0; i < ventaController.articulosActivos.length; i++) {
        if (barcodeScanres == ventaController.articulosActivos[i].codigo) {
          ventaController
              .addArticuloVenta(ventaController.articulosActivos[i].copy());
          formController.cantidad.text = '1';

          ventaController.calcularTotales();
          return;
        }
      }
      const CustomToast(mensaje: 'No se encontro articulo').showToast(context);
    }
  }
}

class _TablaArticulosVenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ventaController = Provider.of<VentaController>(context);

    return Form(
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: _crearTabla(context, ventaController.articulosVenta),
      ),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<ArticuloModel> articulos) {
    final ventaController = Provider.of<VentaController>(context);
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

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

    const boxDecorationCellLeft = BoxDecoration(
      border: Border(
        left: BorderSide(color: Colors.black54),
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
              child: Text('Cantidad', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
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
              child: Text('Descuento', style: textColumStyle),
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
      ]),
    );

    for (int i = 0; i < articulos.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 2 != 0 ? Colors.white10 : Colors.white10,
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
                  controller: ventaController.articulosFormVenta[i].cantidad,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Cantidad'),
                  onChanged: (value) {},
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
                  controller: ventaController.articulosFormVenta[i].precioVenta,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Precio'),
                  onChanged: (value) {},
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
                  controller: ventaController.articulosFormVenta[i].descuento,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Descuento'),
                  onChanged: (value) {},
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
                  controller: ventaController.articulosFormVenta[i].subtotal,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Subtotal'),
                  onChanged: (value) {},
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
    final ventaController =
        Provider.of<VentaController>(context, listen: false);
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(roundedRectangleBorder),
        backgroundColor: MaterialStateProperty.all(Colores.dangerColor),
      ),
      onPressed: () {
        ventaController.quitarArticuloVenta(articulo.idArticulo);
      },
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  _botonCalcular(BuildContext context, int index) {
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      child: const Icon(Icons.calculate_outlined, color: Colors.white),
      onPressed: () {
        final ventaController =
            Provider.of<VentaController>(context, listen: false);

        TextEditingController cantidad1 = TextEditingController(text: '1');
        TextEditingController precio1 = TextEditingController(
            text: ventaController.articulosFormVenta[index].precioVenta.text
                .toString());
        TextEditingController cantidad2 = TextEditingController(text: '1');
        TextEditingController precio2 = TextEditingController(
            text: ventaController.articulosFormVenta[index].precioVenta.text
                .toString());

        showDialog(
          context: context,
          builder: (_) {
            return SimpleDialog(
              shape: roundedRectangleBorder,
              title: const Text('Calculadora de Precios'),
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
                            hintText: 'Cantidad',
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
                        inputFormatters: <FilteringTextInputFormatter>[
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
                    _okButtonCalculadora(context, index, cantidad2),
                    const SizedBox(width: 10),
                    _cancelButtonCalculadora(context),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  _okButtonCalculadora(
      BuildContext context, int index, TextEditingController cantidad) {
    final ventaController =
        Provider.of<VentaController>(context, listen: false);

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
          backgroundColor: MaterialStateProperty.all(Colors.green)),
      onPressed: () {
        (cantidad.text == '')
            ? ventaController.articulosFormVenta[index].cantidad.text = '0'
            : ventaController.articulosFormVenta[index].cantidad.text =
                cantidad.text.toString();
        ventaController.calcularTotales();
        Navigator.pop(context);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          'Agregar Cantidad',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  _cancelButtonCalculadora(BuildContext context) => TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100))),
            backgroundColor: MaterialStateProperty.all(Colors.red)),
        onPressed: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
}

class _TablaArticulosMuestra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ventaController = Provider.of<VentaController>(context);

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: _crearTabla(context, ventaController.articulosActivos),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<ArticuloModel> articulos) {
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

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

    const boxConstrainsts = BoxConstraints(maxWidth: 250);

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
              child: Text('Descripción', style: textColumStyle),
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
        color: i % 2 != 0 ? Colors.white10 : Colors.white10,
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
              constraints: boxConstrainsts,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainsts,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].categoria.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainsts,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].descripcion),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainsts,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].codigo),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainsts,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('${articulos[i].stock}'),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstrainsts,
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
    final ventaController =
        Provider.of<VentaController>(context, listen: false);
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colores.warningColor)),
      onPressed: () {
        ventaController.addArticuloVenta(articulo);
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

class _BotonesFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ventasController = Provider.of<VentaController>(context);
    VentasFormController formController = VentasFormController();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.description_outlined,
                  color: Colores.textColorButton),
              label: Text('Reporte Ventas', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(Colores.successColor),
              onPressed: () {
                ventasController.pantallaActiva = 0;
                ventasController.getVentas();
              },
            ),
          ),
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.post_add, color: Colores.textColorButton),
              label: Text('Registrar Venta', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(Colores.secondaryColor),
              onPressed: () {
                FocusManager.instance.primaryFocus!.unfocus();
                if (formController.isValidForm &&
                    formController.isValidFormVenta) {
                  if (ventasController.articulosVenta.isEmpty) {
                    const CustomToast(mensaje: 'Ingresa un producto')
                        .showToast(context);
                  } else {
                    ventasController.registrarVenta().then((value) async {
                      final format = DateFormat("yyyy-MM-dd");
                      formController.fecha.text = format.format(DateTime.now());

                      UserPreferencesSecure userPrefences =
                          UserPreferencesSecure();
                      String nombreTienda =
                          await userPrefences.getNombreTienda();
                      String nombreSucursal =
                          await userPrefences.getNombreSucursal();

                      formController.serie.text =
                          '${nombreTienda.substring(0, 3)}${nombreTienda.substring(nombreTienda.length - 1)}_${nombreSucursal.substring(0, 3)}${nombreSucursal.substring(nombreSucursal.length - 1)}';
                      formController.nVenta.text =
                          (await userPrefences.getNumVenta()).toString();
                      formController.comprobante = 'Ticket';

                      ventasController.articulosVenta = [];
                      ventasController.articulosFormVenta = [];

                      const CustomToast(
                              mensaje: 'Venta registrada correctamente')
                          .showToast(context);

                      await ventasController.getClientesActivos();
                      await ventasController.getArticulosActivos();
                    });
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
