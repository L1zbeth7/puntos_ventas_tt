import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class VentaController extends ChangeNotifier {
  bool _isLoading = false;
  int _pantallaActiva = 0;
  bool _valorSwitch = true;
  bool _buscarVacio = true;
  String _clienteSelect = '';
  String _comprobante = 'Ticket';

  List<VentaModelV> _ventas = [];
  List<VentaModelV> _ventasBuscar = [];
  List<PersonaModel> _clientesAcvtivos = [];
  List<ArticuloModel> _articulosAcvtivos = [];
  List<ArticuloModel> _articulosVenta = [];
  List<ArticuloVentaFormController> _articulosFormVenta = [];

  final _format = DateFormat("yyyy-MM-dd hh:mm:ss");

  // List<CategoriaModel> _categorias = [];
  // List<CategoriaModel> _categoriasBuscar = [];

  final UserPreferencesSecure _userPreferences = UserPreferencesSecure();

  bool get isLoading => _isLoading;

  int get pantallaActiva => _pantallaActiva;

  set pantallaActiva(int value) {
    _pantallaActiva = value;
    notifyListeners();
  }

  bool get valorSwitch => _valorSwitch;

  set valorSwitch(bool value) {
    _valorSwitch = value;
    notifyListeners();
  }

  bool get buscarVacio => _buscarVacio;

  set buscarVacio(bool value) {
    VentasFormController formController = VentasFormController();
    if (value) formController.buscar.text = '';
    _buscarVacio = value;
    notifyListeners();
  }

  String get clienteSelect => _clienteSelect;
  set clienteSelect(String value) {
    _clienteSelect = value;
    notifyListeners();
  }

  String get comprobante => _comprobante;
  set comprobante(String value) {
    _comprobante = value;
    notifyListeners();
  }

  List<VentaModelV> get ventas => _ventas;
  List<VentaModelV> get ventasBuscar => _ventasBuscar;
  List<PersonaModel> get clientesActivos => _clientesAcvtivos;
  List<ArticuloModel> get articulosActivos => _articulosAcvtivos;

  List<ArticuloModel> get articulosVenta => _articulosVenta;
  set articulosVenta(List<ArticuloModel> value) {
    _articulosVenta = value;
    notifyListeners();
  }

  List<ArticuloVentaFormController> get articulosFormVenta =>
      _articulosFormVenta;
  set articulosFormVenta(List<ArticuloVentaFormController> value) {
    _articulosFormVenta = value;
    notifyListeners();
  }

  void addArticuloVenta(ArticuloModel articulo) {
    VentasFormController formController = VentasFormController();

    double cantidad = double.tryParse(formController.cantidad.text) ?? 1;
    if (cantidad == 0) {
      cantidad = 1;
    }

    for (int i = 0; i < articulosVenta.length; i++) {
      if (articulo.codigo == articulosVenta[i].codigo) {
        double cantidadActual =
            double.parse(_articulosFormVenta[i].cantidad.text);
        if (cantidad > 0) {
          _articulosFormVenta[i].cantidad.text =
              (cantidadActual + cantidad).toString();
        } else {
          _articulosFormVenta[i].cantidad.text =
              (cantidadActual + 1).toString();
        }

        calcularTotales();

        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    ArticuloVentaFormController articuloVentaFormController =
        ArticuloVentaFormController();

    articuloVentaFormController.cantidad.text = '1';
    articuloVentaFormController.precioVenta.text =
        articulo.precioVenta.toString();
    articuloVentaFormController.descuento.text = '0';
    articuloVentaFormController.subtotal.text = '0';

    if (cantidad > 0) {
      articuloVentaFormController.cantidad.text = '$cantidad';
    }

    _articulosVenta.add(articulo);
    _articulosFormVenta.add(articuloVentaFormController);

    calcularTotales();

    _isLoading = false;
    notifyListeners();
  }

  void quitarArticuloVenta(String id) {
    for (int i = 0; i < _articulosVenta.length; i++) {
      if (_articulosVenta[i].idArticulo == id) {
        _articulosVenta.removeAt(i);
        _articulosFormVenta.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

  void calcularTotales() {
    VentasFormController formController = VentasFormController();
    double total = 0;
    double recibe = double.parse(
        formController.recibe.text == '' || formController.recibe.text == '0'
            ? '0'
            : formController.recibe.text);
    for (int i = 0; i < _articulosVenta.length; i++) {
      double cantidad =
          double.tryParse(_articulosFormVenta[i].cantidad.text) != null
              ? double.parse(_articulosFormVenta[i].cantidad.text)
              : 0;
      double precio =
          double.tryParse(_articulosFormVenta[i].precioVenta.text) != null
              ? double.parse(_articulosFormVenta[i].precioVenta.text)
              : 0;

      double descuento =
          double.tryParse(_articulosFormVenta[i].descuento.text) != null
              ? double.parse(_articulosFormVenta[i].descuento.text)
              : 0;

      double subTotal = (cantidad * precio) - descuento;

      total += subTotal;

      _articulosFormVenta[i].subtotal.text = (subTotal.toStringAsFixed(2));
    }

    double impuesto = 0;

    if (formController.impuesto.text != '') {
      double? impuestoNumber = double.tryParse(formController.impuesto.text);
      impuesto = impuestoNumber ?? 0;
    }

    formController.totalCuenta.text = total.toStringAsFixed(2);

    formController.cambio.text = (recibe - total + impuesto).toStringAsFixed(2);
  }

  void removeArticuloVenta(String id) {
    for (int i = 0; i < articulosVenta.length; i++) {
      if (_articulosVenta[i].idArticulo == id) {
        _articulosVenta.removeAt(i);
        _articulosFormVenta.removeAt(i);
        break;
      }
    }
  }

  Future<void> getClientesActivos() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();

    _clientesAcvtivos = [];

    var categoriasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Cliente')
        .get();

    for (var element in categoriasReference.docs) {
      _clientesAcvtivos.add(PersonaModel.fromJson(element.data()));
    }

    for (var element in _clientesAcvtivos) {
      if (element.nombre.toLowerCase().contains('publico')) {
        _clienteSelect = element.id;
        break;
      }
    }

    if (clienteSelect.isEmpty) {
      _clientesAcvtivos.first.id;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getArticulosActivos() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    _articulosAcvtivos = [];

    var articulosReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo')
        .where('activo', isEqualTo: true)
        .where('stock', isGreaterThan: 0)
        .get();

    for (var element in articulosReference.docs) {
      _articulosAcvtivos.add(ArticuloModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getVentas() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    _ventas = [];

    var fechahoy = DateTime.now();

    var fechahoyMin =
        DateTime(fechahoy.year, fechahoy.month, fechahoy.day, 0, 0, 0, 0, 0);
    var fechahoyMax = fechahoyMin;
    fechahoyMax =
        fechahoyMax.add(const Duration(hours: 23, minutes: 59, seconds: 59));

    var ventasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Venta')
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(fechahoyMin))
        .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fechahoyMax))
        .orderBy('fecha', descending: true)
        .get();

    for (var element in ventasReference.docs) {
      _ventas.add(VentaModelV.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarVenta() async {
    _isLoading = true;
    notifyListeners();

    var user = FirebaseAuth.instance.currentUser!;

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();
    String sucursalSelectNombre = await _userPreferences.getNombreSucursal();

    var ventasReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Venta');

    late PersonaModel clienteSelect;

    for (var element in _clientesAcvtivos) {
      if (element.id == _clienteSelect) {
        clienteSelect = element;
      }
    }

    VentasFormController formController = VentasFormController();

    ClienteVentaModel cliente = ClienteVentaModel(
      idCliente: clienteSelect.id,
      nombre: clienteSelect.nombre,
      direccion: clienteSelect.direccion,
      email: clienteSelect.email,
      telefono: clienteSelect.telefono,
    );

    List<ArticuloVentaModel> detalle = [];
    for (int i = 0; i < _articulosVenta.length; i++) {
      detalle.add(ArticuloVentaModel(
        idArticulo: _articulosVenta[i].idArticulo,
        articulo: _articulosVenta[i].nombre,
        codigo: _articulosVenta[i].codigo,
        cantidad: double.parse(_articulosFormVenta[i].cantidad.text),
        precioVenta: double.parse(_articulosFormVenta[i].precioVenta.text),
        descuento: double.parse(_articulosFormVenta[i].descuento.text),
        subtotal: double.parse(_articulosFormVenta[i].subtotal.text),
      ));
    }

    UsuarioVentaModel usuario =
        UsuarioVentaModel(idUsuario: user.uid, nombre: user.displayName!);

    SucursalVentaModel sucursal = SucursalVentaModel(
        idSucursal: sucursalSelect, nombre: sucursalSelectNombre);

    var documetReference = await ventasReference.add({});
    formController.idventa = documetReference.id;
    VentaModelV venta = VentaModelV(
      cliente: cliente,
      fecha: Timestamp.fromDate(DateTime.now()),
      impuesto: formController.impuesto.text == ''
          ? 0
          : double.parse(formController.impuesto.text),
      serieComprobante: formController.serie.text,
      detalle: detalle,
      totalVenta: double.parse(formController.totalCuenta.text),
      numeroComprobante: formController.nVenta.text,
      tipoComprobante: formController.comprobante,
      activo: true,
      idVenta: formController.idventa,
      usuario: usuario,
      sucursal: sucursal,
    );
    await documetReference.update(venta.toJson());

    formController.limpiarFormulario();
    _valorSwitch = true;

    _userPreferences.setNumVenta((await _userPreferences.getNumVenta()) + 1);
    formController.nVenta.text =
        (await _userPreferences.getNumVenta()).toString();

    for (var element in detalle) {
      await actualizarArticulo(element.idArticulo, element.cantidad);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> actualizarArticulo(String id, double cantidad) async {
    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    var articulosReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo')
        .doc(id);

    var articulo =
        ArticuloModel.fromJson((await articulosReference.get()).data()!);

    articulosReference.update({"stock": articulo.stock - cantidad});
  }

  Future<void> cancelarVenta(String idVenta) async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();
    var ventasReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Venta')
        .doc(idVenta);

    VentaModelV ventaData =
        VentaModelV.fromJson((await ventasReference.get()).data()!);

    ventasReference.update({'activo': false});

    var articulosReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo');

    for (var element in ventaData.detalle) {
      var articuloReference = articulosReference.doc(element.idArticulo);
      var articulo = await articuloReference.get();
      var articuloData = ArticuloModel.fromJson(articulo.data()!);
      articuloReference.update({
        'stock': articuloData.stock + element.cantidad,
        'tipoComprobante': 'Devolucion',
      });
    }

    getVentas();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelarDevolucion(String idVenta) async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();
    var ventasReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Venta')
        .doc(idVenta);

    VentaModelV ventaData =
        VentaModelV.fromJson((await ventasReference.get()).data()!);

    ventasReference.update({'activo': false});

    var articulosReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo');

    for (var element in ventaData.detalle) {
      var articuloReference = articulosReference.doc(element.idArticulo);
      var articulo = await articuloReference.get();
      var articuloData = ArticuloModel.fromJson(articulo.data()!);
      articuloReference.update({
        'stock': articuloData.stock - element.cantidad,
        'tipoComprobante': 'Devolucion',
      });
    }

    getVentas();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReporte({bool buscar = false}) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawString(
        'Ventas', PdfStandardFont(PdfFontFamily.helvetica, 25),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 50));

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 8);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Fecha';
    headerRow.cells[1].value = 'Cliente';
    headerRow.cells[2].value = 'Usuario';
    headerRow.cells[3].value = 'Documento';
    headerRow.cells[4].value = 'Numero';
    headerRow.cells[5].value = 'Total Venta';
    headerRow.cells[6].value = 'Sucursal';
    headerRow.cells[7].value = 'Estado';

    headerRow.style = PdfGridRowStyle(
      backgroundBrush: PdfSolidBrush(
        PdfColor(
          Colores.secondaryColor.red,
          Colores.secondaryColor.green,
          Colores.secondaryColor.blue,
        ),
      ),
      textBrush: PdfBrushes.white,
    );

    List<VentaModelV> categoriasReporte = _ventas;

    if (buscar == true) categoriasReporte = _ventasBuscar;

    for (int i = 0; i < categoriasReporte.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = _format.format(categoriasReporte[i].fecha.toDate());
      row.cells[1].value = categoriasReporte[i].cliente.nombre;
      row.cells[2].value = categoriasReporte[i].usuario.nombre;
      row.cells[3].value = categoriasReporte[i].tipoComprobante;
      row.cells[4].value =
          '${categoriasReporte[i].serieComprobante}-${categoriasReporte[i].numeroComprobante}';
      row.cells[5].value = '\$${categoriasReporte[i].totalVenta}';
      row.cells[6].value = categoriasReporte[i].sucursal.nombre;
      row.cells[7].value =
          categoriasReporte[i].activo ? 'Aceptado' : 'Cancelado';
      row.style = PdfGridRowStyle(
          backgroundBrush: i % 2 != 0
              ? PdfBrushes.white
              : PdfSolidBrush(PdfColor(200, 200, 200)));
    }

    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 60, page.getClientSize().width, page.getClientSize().height),
    );

    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (await File('${appDocDir.path}/Ventas.pdf').exists()) {
      await File('${appDocDir.path}/Ventas.pdf').delete();
    }

    File('${appDocDir.path}/Ventas.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Ventas.pdf');

    document.dispose();
  }

  void buscarVenta() {
    VentasFormController formController = VentasFormController();
    _ventasBuscar = [];
    for (var element in _ventas) {
      var fecha = _format
          .format(element.fecha.toDate())
          .toLowerCase()
          .contains(formController.buscar.text);

      var cliente = element.cliente.nombre
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());

      var documento = element.tipoComprobante
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var numero = element.numeroComprobante
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var serieNumero =
          ('${element.serieComprobante}-${element.numeroComprobante}')
              .toLowerCase()
              .contains(formController.buscar.text.toLowerCase());
      var sucursal = element.sucursal.nombre
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var totalVenta = int.tryParse(formController.buscar.text);

      if (fecha ||
          cliente ||
          documento ||
          numero ||
          serieNumero ||
          sucursal ||
          (totalVenta == null
              ? false
              : int.parse(formController.buscar.text) == element.totalVenta)) {
        _ventasBuscar.add(element);
      }
    }
  }

  getTicket(VentaModelV venta) async {
    double altura = ((8.33) * venta.detalle.length) + 75;

    final PdfDocument document = PdfDocument();
    document.pageSettings.size = Size(
      300,
      altura < 300 ? 300 : altura,
    );

    document.pageSettings.orientation = PdfPageOrientation.portrait;

    final PdfPage page = document.pages.add();

    final Size pageSize = page.getClientSize();

    double alto = 0;

    page.graphics.drawString(
      'Tlati Digital',
      PdfStandardFont(PdfFontFamily.helvetica, 25),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle),
      bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 30),
    );
    alto += 30;

    page.graphics.drawString('Cliente: ${venta.cliente.nombre}',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 10));
    alto += 10;

    page.graphics.drawString(
        'N° Venta: ${'${venta.serieComprobante}-${venta.numeroComprobante}'}',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 10));
    alto += 10;

    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.gridTable2);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'CANTIDAD';
    headerRow.cells[1].value = 'DESCRIPCIÓN';
    headerRow.cells[2].value = 'IMPORTE';

    headerRow.style = PdfGridRowStyle();

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 80, pageSize.width, 95),
    );
    alto = 60;

    page.graphics.drawString('=====================================',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, alto, page.size.width, alto + 15));
    alto += 15;

    final PdfGrid gridDetalle = PdfGrid();
    gridDetalle.columns.add(count: 3);
    gridDetalle.applyBuiltInStyle(PdfGridBuiltInStyle.gridTable2);

    double total = 0;
    double nProductos = 0;

    for (int i = 0; i < venta.detalle.length; i++) {
      PdfGridRow row = gridDetalle.rows.add();

      row.cells[0].value = venta.detalle[i].cantidad.toString();
      row.cells[1].value = venta.detalle[i].articulo;
      row.cells[2].value = '\$${venta.detalle[i].subtotal}';

      row.style = PdfGridRowStyle(
          backgroundBrush: i % 2 != 0
              ? PdfBrushes.white
              : PdfSolidBrush(PdfColor(200, 200, 200)));

      total += venta.detalle[i].subtotal;
      nProductos += venta.detalle[i].cantidad;
    }

    PdfGridRow row = gridDetalle.rows.add();

    row.cells[0].value = 'N° prodductos: $nProductos';
    //row.cells[1].value = '';
    row.cells[2].value = 'Total: \$$total';

    row.style = PdfGridRowStyle(
        backgroundBrush: venta.detalle.length % 2 != 0
            ? PdfBrushes.white
            : PdfSolidBrush(PdfColor(200, 200, 200)));

    // gridDetalle.style.cellPadding = PdfPaddings(left: 5, top: 5);

    gridDetalle.draw(
      page: page,
      bounds: Rect.fromLTWH(0, alto + 30, pageSize.width, pageSize.height - 25),
    );

    alto += (10) * (venta.detalle.length + 1);
    page.graphics.drawString(
      '¡Gracias por su compra!',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle),
      bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 15),
    );

    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (await File('${appDocDir.path}/Ticket.pdf').exists()) {
      await File('${appDocDir.path}/Ticket.pdf').delete();
    }

    File('${appDocDir.path}/Ticket.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Ticket.pdf');

    document.dispose();
  }

  getBoleta(VentaModelV venta) async {
    final PdfDocument document = PdfDocument();
    document.pageSettings.size = PdfPageSize.letter;

    document.pageSettings.orientation = PdfPageOrientation.portrait;
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    double alto = 0;

    page.graphics.drawString(
      'Tlati Digital',
      PdfStandardFont(PdfFontFamily.helvetica, 25),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle),
      bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 30),
    );
    alto += 30;

    page.graphics.drawString('Cliente: ${venta.cliente.nombre}',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 10));
    alto += 10;

    page.graphics.drawString('Domicilio: ${venta.cliente.direccion}',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 10));
    alto += 10;

    page.graphics.drawString('Telefono: ${venta.cliente.telefono}',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 10));
    alto += 10;

    page.graphics.drawString('Correo: ${venta.cliente.email}',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 10));
    alto += 10;

    page.graphics.drawString(
        'N° Venta: ${'${venta.serieComprobante}-${venta.numeroComprobante}'}',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 10));
    alto += 20;

    final PdfGrid gridDetalle = PdfGrid();
    gridDetalle.columns.add(count: 3);
    gridDetalle.applyBuiltInStyle(PdfGridBuiltInStyle.gridTable2);

    double total = 0;
    double nProductos = 0;

    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 6);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Codigo';
    headerRow.cells[1].value = 'Descripcion';
    headerRow.cells[2].value = 'Cantidad';
    headerRow.cells[3].value = 'P/U';
    headerRow.cells[4].value = 'Descuento';
    headerRow.cells[5].value = 'subtotal';

    headerRow.style = PdfGridRowStyle(
      backgroundBrush: PdfSolidBrush(
        PdfColor(
          Colores.secondaryColor.red,
          Colores.secondaryColor.green,
          Colores.secondaryColor.blue,
        ),
      ),
      textBrush: PdfBrushes.white,
    );

    for (int i = 0; i < venta.detalle.length; i++) {
      PdfGridRow row = grid.rows.add();

      row.cells[0].value = venta.detalle[i].codigo;
      row.cells[1].value = venta.detalle[i].articulo;
      row.cells[2].value = venta.detalle[i].cantidad.toString();
      row.cells[3].value = '\$${venta.detalle[i].precioVenta}';
      row.cells[4].value = '\$${venta.detalle[i].descuento}';
      row.cells[5].value = '\$${venta.detalle[i].subtotal}';

      row.style = PdfGridRowStyle(
          backgroundBrush: i % 2 != 0
              ? PdfBrushes.white
              : PdfSolidBrush(PdfColor(200, 200, 200)));

      total += venta.detalle[i].subtotal;
      nProductos += venta.detalle[i].cantidad;
    }

    PdfGridRow row = grid.rows.add();

    row.cells[1].value = 'N° prodductos: $nProductos';
    //row.cells[1].value = '';
    row.cells[3].value = 'Total: \$$total';

    row.style = PdfGridRowStyle(
        backgroundBrush: venta.detalle.length % 2 != 0
            ? PdfBrushes.white
            : PdfSolidBrush(PdfColor(200, 200, 200)));

    // gridDetalle.style.cellPadding = PdfPaddings(left: 5, top: 5);

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, alto + 30, pageSize.width, pageSize.height - 25),
    );

    alto += (10) * (venta.detalle.length + 1);

    page.graphics.drawString(
      '¡Gracias por su compra!',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle),
      bounds: Rect.fromLTWH(0, alto, pageSize.width, alto + 15),
    );

    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (await File('${appDocDir.path}/Ticket.pdf').exists()) {
      await File('${appDocDir.path}/Ticket.pdf').delete();
    }

    File('${appDocDir.path}/Ticket.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Ticket.pdf');

    document.dispose();
  }
}
