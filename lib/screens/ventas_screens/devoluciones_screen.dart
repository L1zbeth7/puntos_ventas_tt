import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/screens/screens.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class DevolucionesScreen extends StatelessWidget {
  static String routePage = 'DevolucionesScreen';
  const DevolucionesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: Appbar.AppbarStyle(title: 'Devoluciones'),
        drawer: DrawerMenu(routeActual: routePage),
        body: Stack(children: [
          BackgroundImg(),
          Padding(
            padding: const EdgeInsets.all(25),
            child: _PantallaPrincipal(),
          ),
        ]),
      ),
    );
  }
}

class _PantallaPrincipal extends StatelessWidget {
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
    DevolucionFormController formController = DevolucionFormController();

    return Form(
      key: formController.formKeyDevolucion,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text('Devolución', style: StyleTexto.styleTextSubtitle),
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
                    keyboardType: TextInputType.number,
                    decoration: StyleTexto.getInputStyle('Impuesto'),
                    enabled: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,3}'))
                    ],
                    validator: (value) {
                      if (value == '') return 'Ingresa un valor';
                      double numero = double.parse(value!);
                      if (numero < 0) {
                        return 'No ingresar números negativos';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 15),
            // Container(
            //   decoration: StyleTexto.boxDecorationCard,
            //   margin: const EdgeInsets.all(10),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(25),
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       physics: const BouncingScrollPhysics(),
            //       child: _TablaArticulosMuestra(),
            //     ),
            //   ),
            // ),
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
    final devolucionController = Provider.of<DevolucionesController>(context);

    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.green,
      value: devolucionController.comprobante,
      decoration: StyleTexto.getInputStyle('Comprobante'),
      items: getItemsComprobante(context),
      isExpanded: true,
      onChanged: null,
    );
  }

  List<DropdownMenuItem<String>> getItemsComprobante(BuildContext context) {
    List<DropdownMenuItem<String>> items = [];

    items.add(
      const DropdownMenuItem(value: 'Devolución', child: Text('Devolución')),
    );
    return items;
  }
}

class _Formulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DevolucionFormController formController = DevolucionFormController();

    return Form(
      key: formController.formKey,
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
                        child: Icon(Icons.camera_alt_outlined,
                            color: Colores.textColorButton),
                        onPressed: () {
                          _escanerCamara(context);
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
                    borderRadius: BorderRadius.circular(15),
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
          //_BotonesFormulario(),
        ],
      ),
    );
  }

  _escanerCamara(BuildContext context) async {
    final devolucionController =
        Provider.of<DevolucionesController>(context, listen: false);
    DevolucionFormController formController = DevolucionFormController();

    String barcodeScanres = await FlutterBarcodeScanner.scanBarcode(
        '#3d8BEF', 'Cancelar', false, ScanMode.BARCODE);

    FocusManager.instance.primaryFocus!.unfocus();

    if (barcodeScanres == '-1') {
      const CustomToast(mensaje: 'No se escaneo articulo').showToast(context);
    } else {
      for (int i = 0; i < devolucionController.articulosActivos.length; i++) {
        if (barcodeScanres == devolucionController.articulosActivos[i].codigo) {
          devolucionController.addArticuloDevolucion(
              devolucionController.articulosActivos[i].copy());
          formController.cantidad.text = '1';
          devolucionController.calcularTotales();

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
    final devolucionController = Provider.of<DevolucionesController>(context);

    return Form(
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children:
            _crearTabla(context, devolucionController.articulosDevolucion),
      ),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<ArticuloModel> articulos) {
    final devolucionController = Provider.of<DevolucionesController>(context);
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    // List<ArticuloModel> articulos = List.generate(
    //   3,
    //   (index) => ArticuloModel(
    //       activo: true,
    //       categoria: CategoriaModel(
    //           activo: true,
    //           descripcion: 'descripcion',
    //           idCategoria: 'idCategoria',
    //           nombre: 'nombre',
    //           porcentaje: 5),
    //       descripcion: 'descripcion',
    //       nombre: 'nombre',
    //       codigo: 'codigo',
    //       idArticulo: 'idArticulo',
    //       imagen: 'imagen',
    //       precioVenta: 84.3,
    //       stock: 9.7),
    // );

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
                      _botonCalculadora(context, i)
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
              child: Center(child: Text(articulos[i].nombre)),
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
                      devolucionController.articulosFormVenta[i].cantidad,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Cantidad'),
                  onChanged: (value) {
                    devolucionController.calcularTotales();
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
                      devolucionController.articulosFormVenta[i].precioVenta,
                  keyboardType: TextInputType.number,
                  enabled: false,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Precio'),
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
                      devolucionController.articulosFormVenta[i].descuento,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,3}'))
                  ],
                  decoration: StyleTexto.getInputStyle('Descuento'),
                  onChanged: (value) {
                    devolucionController.calcularTotales();
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
                      devolucionController.articulosFormVenta[i].subtotal,
                  keyboardType: TextInputType.number,
                  enabled: false,
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
    final devolucionController =
        Provider.of<DevolucionesController>(context, listen: false);
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colores.dangerColor)),
      child: const Icon(Icons.delete, color: Colors.white),
      onPressed: () {
        devolucionController.quitarArticuloDevolucion(articulo.idArticulo);
      },
    );
  }

  _botonCalculadora(BuildContext context, int index) {
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
          backgroundColor: MaterialStateProperty.all(Colors.green)),
      child: const Icon(Icons.calculate_outlined, color: Colors.white),
      onPressed: () {
        final devolucionController =
            Provider.of<DevolucionesController>(context, listen: false);

        TextEditingController cantidad1 = TextEditingController(text: '1');
        TextEditingController precio1 = TextEditingController(
            text: devolucionController
                .articulosFormVenta[index].precioVenta.text
                .toString());
        TextEditingController cantidad2 = TextEditingController(text: '1');
        TextEditingController precio2 = TextEditingController(
            text: devolucionController
                .articulosFormVenta[index].precioVenta.text
                .toString());

        showDialog(
          context: context,
          builder: (_) {
            return SimpleDialog(
              shape: roundedRectangleBorder,
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
    final devolucionController = Provider.of<DevolucionesController>(context);

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
          backgroundColor: MaterialStateProperty.all(Colors.green)),
      onPressed: () {
        (cantidad.text == '')
            ? devolucionController.articulosFormVenta[index].cantidad.text = '0'
            : devolucionController.articulosFormVenta[index].cantidad.text =
                cantidad.text.toString();
        devolucionController.calcularTotales();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text('Agregar cantidad', style: StyleTexto.styleTextbutton),
      ),
    );
  }

  _cancelButtonCalculadora(BuildContext context) => TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)))),
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
    final devolucionController = Provider.of<DevolucionesController>(context);

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: _crearTabla(context, devolucionController.articulosActivos),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<ArticuloModel> articulos) {
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    List<ArticuloModel> articulos = List.generate(
      3,
      (index) => ArticuloModel(
          activo: true,
          categoria: CategoriaModel(
              activo: true,
              descripcion: 'descripcion',
              idCategoria: 'idCategoria',
              nombre: 'nombre',
              porcentaje: 10),
          descripcion: 'descripcion',
          nombre: 'nombre',
          codigo: 'codigo',
          idArticulo: 'idArticulo',
          imagen: 'imagen',
          precioVenta: 250.9,
          stock: 7.4),
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
    final devolucionController =
        Provider.of<DevolucionesController>(context, listen: false);
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            shape: MaterialStateProperty.all(roundedRectangleBorder),
            backgroundColor: MaterialStateProperty.all(Colores.warningColor)),
        onPressed: () {
          devolucionController.addArticuloDevolucion(articulo);
        },
        child: Icon(Icons.add, color: Colores.textColorButton));
  }
}

class _BotonesFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final devolucionController = Provider.of<DevolucionesController>(context);
    DevolucionFormController formController = DevolucionFormController();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.description_outlined,
                  color: Colores.textColorButton, size: 28),
              label: Text('Reporte Ventas',
                  style: StyleTexto.styleTextbutton,
                  textAlign: TextAlign.center),
              style: StyleTexto.getButtonStyle(Colores.successColor),
              onPressed: () {
                final ventasController =
                    Provider.of<VentaController>(context, listen: false);
                ventasController.getVentas();
                Navigator.pushReplacementNamed(context, VentaScreen.routePage);
              },
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.post_add,
                  color: Colores.textColorButton, size: 28),
              label: Text('Registrar Devolución',
                  style: StyleTexto.styleTextbutton,
                  textAlign: TextAlign.center),
              style: StyleTexto.getButtonStyle(Colores.dangerColor),
              onPressed: () {
                FocusManager.instance.primaryFocus!.unfocus();
                if (formController.isValidForm &&
                    formController.isValidFormDevolucion) {
                  if (devolucionController.articulosDevolucion.isEmpty) {
                    const CustomToast(mensaje: 'Ingresa un producto')
                        .showToast(context);
                  } else {
                    devolucionController.registrarDevolucion().then(
                      (value) async {
                        final ventasController = Provider.of<VentaController>(
                            context,
                            listen: false);
                        ventasController.getVentas();
                        Navigator.pushReplacementNamed(
                            context, VentaScreen.routePage);
                      },
                    );
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
