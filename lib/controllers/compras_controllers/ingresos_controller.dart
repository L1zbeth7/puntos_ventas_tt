import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class IngresosController extends ChangeNotifier {
  bool _isLoading = false;
  int _pantallaActiva = 0;
  bool _valorSwitch = true;
  bool _buscarVacio = true;
  String _proveedorSelect = '';
  String _comprobante = 'Ticket';

  List<IngresoModel> _ingresos = [];
  List<IngresoModel> _ingresosBuscar = [];
  List<PersonaModel> _proveedoresActivos = [];
  List<ArticuloModel> _articulosAcvtivos = [];
  List<ArticuloModel> _articulosIngreso = [];
  List<ArticuloIngresoFormController> _articulosFormIngreso = [];

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

  String get proveedorSelect => _proveedorSelect;
  set proveedorSelect(String value) {
    _proveedorSelect = value;
    notifyListeners();
  }

  String get comprobante => _comprobante;
  set comprobante(String value) {
    _comprobante = value;
    notifyListeners();
  }

  List<IngresoModel> get ingresos => _ingresos;
  List<IngresoModel> get ingresosBuscar => _ingresosBuscar;
  List<PersonaModel> get proveedoresActivos => _proveedoresActivos;
  List<ArticuloModel> get articulosActivos => _articulosAcvtivos;

  List<ArticuloModel> get articulosIngreso => _articulosIngreso;
  set articulosIngreso(List<ArticuloModel> value) {
    _articulosIngreso = value;
    notifyListeners();
  }

  List<ArticuloIngresoFormController> get articulosFormIngreso =>
      _articulosFormIngreso;
  set articulosFormIngreso(List<ArticuloIngresoFormController> value) {
    _articulosFormIngreso = value;
    notifyListeners();
  }

  void addArticuloIngreso(ArticuloModel articulo) {
    IngresoFormController formController = IngresoFormController();

    double cantidad = double.tryParse(formController.cantidad.text) ?? 1;
    if (cantidad == 0) {
      cantidad = 1;
    }

    for (int i = 0; i < articulosIngreso.length; i++) {
      if (articulo.codigo == articulosIngreso[i].codigo) {
        double cantidadActual =
            double.parse(_articulosFormIngreso[i].cantidad.text);
        if (cantidad > 0) {
          _articulosFormIngreso[i].cantidad.text =
              (cantidadActual + cantidad).toString();
        } else {
          _articulosFormIngreso[i].cantidad.text =
              (cantidadActual + 1).toString();
        }

        calcularTotales();

        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    ArticuloIngresoFormController articuloIngresoFormController =
        ArticuloIngresoFormController();

    double precioVentaSugerido =
        ((articulo.precioVenta * articulo.categoria.porcentaje) / 100) +
            articulo.precioVenta;

    articuloIngresoFormController.cantidad.text = '1';
    articuloIngresoFormController.precioCompra.text =
        articulo.precioVenta.toString();
    articuloIngresoFormController.descuento.text = '0';
    articuloIngresoFormController.porcentaje.text =
        articulo.categoria.porcentaje.toString();
    articuloIngresoFormController.precioVenta.text =
        precioVentaSugerido.toString();
    articuloIngresoFormController.subtotal.text = '0';

    if (cantidad > 0) {
      articuloIngresoFormController.cantidad.text = '$cantidad';
    }

    _articulosIngreso.add(articulo);
    _articulosFormIngreso.add(articuloIngresoFormController);

    calcularTotales();

    _isLoading = false;
    notifyListeners();
  }

  void quitarArticuloIngreso(String id) {
    for (int i = 0; i < _articulosIngreso.length; i++) {
      if (_articulosIngreso[i].idArticulo == id) {
        _articulosIngreso.removeAt(i);
        _articulosFormIngreso.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

  void calcularTotales() {
    IngresoFormController formController = IngresoFormController();
    double total = 0;
    double recibe = double.parse(
        formController.recibe.text == '' || formController.recibe.text == '0'
            ? '0'
            : formController.recibe.text);
    for (int i = 0; i < _articulosIngreso.length; i++) {
      double cantidad =
          double.tryParse(_articulosFormIngreso[i].cantidad.text) != null
              ? double.parse(_articulosFormIngreso[i].cantidad.text)
              : 0;
      double precio =
          double.tryParse(_articulosFormIngreso[i].precioCompra.text) != null
              ? double.parse(_articulosFormIngreso[i].precioCompra.text)
              : 0;

      double descuento =
          double.tryParse(_articulosFormIngreso[i].descuento.text) != null
              ? double.parse(_articulosFormIngreso[i].descuento.text)
              : 0;

      double subTotal = (cantidad * precio) - descuento;
      _articulosFormIngreso[i].subtotal.text = (subTotal.toStringAsFixed(2));

      total += subTotal;
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
    for (int i = 0; i < articulosIngreso.length; i++) {
      if (_articulosIngreso[i].idArticulo == id) {
        _articulosIngreso.removeAt(i);
        _articulosFormIngreso.removeAt(i);
        break;
      }
    }
  }

  Future<void> getProveedoresActivos() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();

    _proveedoresActivos = [];

    var categoriasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Proveedor')
        .get();

    for (var element in categoriasReference.docs) {
      _proveedoresActivos.add(PersonaModel.fromJson(element.data()));
    }

    for (var element in _proveedoresActivos) {
      if (element.nombre.toLowerCase().contains('publico')) {
        _proveedorSelect = element.id;
        break;
      }
    }

    if (_proveedorSelect == '') {
      _proveedorSelect = _proveedoresActivos.first.id;
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
        .get();

    for (var element in articulosReference.docs) {
      _articulosAcvtivos.add(ArticuloModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getIngresos() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    _ingresos = [];

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
        .collection('Ingreso')
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(fechahoyMin))
        .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fechahoyMax))
        .orderBy('fecha', descending: true)
        .get();

    for (var element in ventasReference.docs) {
      _ingresos.add(IngresoModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarIngreso() async {
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
        .collection('Ingreso');

    late PersonaModel proveedorSelec;

    for (var element in _proveedoresActivos) {
      if (element.id == _proveedorSelect) {
        proveedorSelec = element;
        break;
      }
    }

    IngresoFormController formController = IngresoFormController();

    ProveedorModel proveedor = ProveedorModel(
        idCliente: proveedorSelec.id, nombre: proveedorSelec.nombre);

    List<ArticuloVentaModel> detalle = [];
    for (int i = 0; i < _articulosIngreso.length; i++) {
      detalle.add(ArticuloVentaModel(
        idArticulo: _articulosIngreso[i].idArticulo,
        articulo: _articulosIngreso[i].nombre,
        codigo: _articulosIngreso[i].codigo,
        cantidad: double.parse(_articulosFormIngreso[i].cantidad.text),
        precioVenta: double.parse(_articulosFormIngreso[i].precioVenta.text),
        descuento: double.parse(_articulosFormIngreso[i].descuento.text),
        subtotal: double.parse(_articulosFormIngreso[i].subtotal.text),
      ));
    }

    UsuarioVentaModel usuario =
        UsuarioVentaModel(idUsuario: user.uid, nombre: user.displayName!);

    SucursalVentaModel sucursal = SucursalVentaModel(
        idSucursal: sucursalSelect, nombre: sucursalSelectNombre);

    var documetReference = await ventasReference.add({});
    formController.idventa = documetReference.id;
    IngresoModel ingreso = IngresoModel(
      proveedor: proveedor,
      fecha: Timestamp.fromDate(DateTime.now()),
      impuesto: formController.impuesto.text == ''
          ? 0
          : double.parse(formController.impuesto.text),
      serieComprobante: formController.serie.text,
      detalle: detalle,
      totalIngreso: double.parse(formController.totalCuenta.text),
      numeroComprobante: formController.nVenta.text,
      tipoComprobante: formController.comprobante,
      activo: true,
      idVenta: formController.idventa,
      usuario: usuario,
      sucursal: sucursal,
    );
    await documetReference.update(ingreso.toJson());

    formController.limpiarFormulario();
    _valorSwitch = true;

    _userPreferences.setNumVenta((await _userPreferences.getNumVenta()) + 1);
    formController.nVenta.text =
        (await _userPreferences.getNumVenta()).toString();

    for (var element in detalle) {
      await actualizarArticulo(
        element.idArticulo,
        element.cantidad,
        element.precioVenta,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> actualizarArticulo(
      String id, double cantidad, double precioVenta) async {
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

    articulosReference.update({
      "stock": articulo.stock + cantidad,
      'precioVenta': precioVenta,
    });
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

    IngresoModel ventaData =
        IngresoModel.fromJson((await ventasReference.get()).data()!);

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

    getIngresos();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelarIngreso(String idIngreso) async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();
    var ventasReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Ingreso')
        .doc(idIngreso);

    IngresoModel ventaData =
        IngresoModel.fromJson((await ventasReference.get()).data()!);

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
      articuloReference
          .update({'stock': articuloData.stock - element.cantidad});
    }

    getIngresos();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReporte({bool buscar = false}) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawString(
        'Ingresos', PdfStandardFont(PdfFontFamily.helvetica, 25),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 50));

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 8);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Fecha';
    headerRow.cells[1].value = 'Proveedor';
    headerRow.cells[2].value = 'Usuario';
    headerRow.cells[3].value = 'Documento';
    headerRow.cells[4].value = 'Numero';
    headerRow.cells[5].value = 'Total Ingreso';
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

    List<IngresoModel> categoriasReporte = _ingresos;

    if (buscar == true) categoriasReporte = _ingresosBuscar;

    for (int i = 0; i < categoriasReporte.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = _format.format(categoriasReporte[i].fecha.toDate());
      row.cells[1].value = categoriasReporte[i].proveedor.nombre;
      row.cells[2].value = categoriasReporte[i].usuario.nombre;
      row.cells[3].value = categoriasReporte[i].tipoComprobante;
      row.cells[4].value =
          '${categoriasReporte[i].serieComprobante}-${categoriasReporte[i].numeroComprobante}';
      row.cells[5].value = '\$${categoriasReporte[i].totalIngreso}';
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

    if (await File('${appDocDir.path}/Ingresos.pdf').exists()) {
      await File('${appDocDir.path}/Ingresos.pdf').delete();
    }

    File('${appDocDir.path}/Ingresos.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Ingresos.pdf');

    document.dispose();
  }

  void buscarIngreso() {
    IngresoFormController formController = IngresoFormController();
    _ingresosBuscar = [];
    for (var element in _ingresos) {
      var fecha = _format
          .format(element.fecha.toDate())
          .toLowerCase()
          .contains(formController.buscar.text);

      var proveedor = element.proveedor.nombre
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
          proveedor ||
          documento ||
          numero ||
          serieNumero ||
          sucursal ||
          (totalVenta == null
              ? false
              : int.parse(formController.buscar.text) ==
                  element.totalIngreso)) {
        _ingresosBuscar.add(element);
      }
    }
  }

  getTicket() async {
    final PdfDocument document =
        PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
    document.pageSettings.size = const Size(300, double.infinity);

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    var fontBuffer =
        (await rootBundle.load('assets/fonts/Acumin/AConceptoBoldMedium.ttf'))
            .buffer;
    List<int> fontBase64 = Uint8List.view(fontBuffer);

    PdfFont font = PdfTrueTypeFont(fontBase64, 12);

    page.graphics.drawString(
      'Tlati digital',
      font,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
      bounds: Rect.fromLTWH(0, 0, pageSize.width, 50),
    );

    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (await File('${appDocDir.path}/Ticket.pdf').exists()) {
      await File('${appDocDir.path}/Ticket.pdf').delete();
    }

    File('${appDocDir.path}/Ticket.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Ticket.pdf');

    document.dispose();
  }

  Future<void> limpiarFormulario() async {
    IngresoFormController formController = IngresoFormController();
    formController.limpiarFormulario();
    await getProveedoresActivos();
    await getArticulosActivos();
    _comprobante = 'Ticket';
    formController.proveedorSeleccionado = _proveedorSelect;
    formController.comprobante = _comprobante;
    _articulosIngreso = [];
    _articulosFormIngreso = [];
    notifyListeners();
  }
}
