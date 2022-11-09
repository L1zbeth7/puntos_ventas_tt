import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class TraspasosController extends ChangeNotifier {
  bool _isLoading = false;
  int _pantallaActiva = 0;
  bool _buscarVacio = true;
  double _maximo = 0;

  String _sucursalSelect = '0';
  String _articuloSelect = '0';
  late ArticuloTraspasoModel articuloTraspaso;
  late SucursalVentaModel sucursalEntrada;
  //controñlladores formularios
  TextEditingController sucursalSalida = TextEditingController();
  TextEditingController cantidad = TextEditingController();
  TextEditingController buscar = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  bool get isValidForm => formKey.currentState?.validate() ?? false;

  List<SucursalVentaModel> _sucursalesActivas = [];
  List<ArticuloTraspasoModel> _articulosTraspaso = [];

  List<TraspasoModel> _traspasos = [];
  List<TraspasoModel> _traspasosBuscar = [];

  final UserPreferencesSecure _userPreferences = UserPreferencesSecure();

  bool get isLoading => _isLoading;

  int get pantallaActiva => _pantallaActiva;

  set pantallaActiva(int value) {
    _pantallaActiva = value;
    notifyListeners();
  }

  bool get buscarVacio => _buscarVacio;

  set buscarVacio(bool value) {
    if (value) buscar.text = '';
    _buscarVacio = value;
    notifyListeners();
  }

  double get maximo => _maximo;
  set maximo(double value) {
    _maximo = value;
    notifyListeners();
  }

  String get sucursalSelect => _sucursalSelect;
  set sucursalSelect(String value) {
    _sucursalSelect = value;
    notifyListeners();
  }

  String get articuloSelect => _articuloSelect;
  set articuloSelect(String value) {
    _articuloSelect = value;
    notifyListeners();
  }

  List<SucursalVentaModel> get sucursalesActivas => _sucursalesActivas;
  List<ArticuloTraspasoModel> get articulosTraspaso => _articulosTraspaso;
  set articulosTraspaso(List<ArticuloTraspasoModel> value) {
    _articulosTraspaso = value;
    notifyListeners();
  }

  List<TraspasoModel> get traspasos => _traspasos;
  List<TraspasoModel> get traspasosBuscar => _traspasosBuscar;

  Future<void> getSucursales() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();
    String nombreSucursal = await _userPreferences.getNombreSucursal();
    sucursalSalida.text = nombreSucursal;

    _sucursalesActivas = [];

    var sucursalesReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .get();

    for (var element in sucursalesReference.docs) {
      var sucursalData = element.data();
      if (sucursalData["idSucursal"] != sucursalSelect) {
        _sucursalesActivas.add(SucursalVentaModel.fromJson(sucursalData));
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getArticulosActivos(String idSucursal) async {
    _isLoading = true;
    notifyListeners();

    _articulosTraspaso = [];

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    var articulosSucursalSalidaReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo')
        .get();

    List<ArticuloTraspasoModel> articulosSucursalSalida = [];
    for (var element in articulosSucursalSalidaReference.docs) {
      articulosSucursalSalida
          .add(ArticuloTraspasoModel.fromJson(element.data()));
    }

    var articulosSucursalEntradaReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(idSucursal)
        .collection('Articulo')
        .get();

    List<ArticuloTraspasoModel> articulosSucursalEntrada = [];
    for (var element in articulosSucursalEntradaReference.docs) {
      articulosSucursalEntrada
          .add(ArticuloTraspasoModel.fromJson(element.data()));
    }

    for (var elementSalida in articulosSucursalSalida) {
      for (var elementEntrada in articulosSucursalEntrada) {
        if (elementSalida.codigo == elementEntrada.codigo) {
          _articulosTraspaso.add(elementSalida);
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarTraspaso() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();
    String sucursalSelectName = await _userPreferences.getNombreSucursal();

    var traspasoReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Traspaso');

    var traspasoDocument = await traspasoReference.add({});
    User usuario = FirebaseAuth.instance.currentUser!;

    articuloTraspaso.stock = double.parse(cantidad.text) as int;

    var traspasoObjet = TraspasoModel(
      fecha: Timestamp.fromDate(DateTime.now()),
      articulo: articuloTraspaso,
      estado: true,
      idTraspaso: traspasoDocument.id,
      usuario: UsuarioVentaModel(
          idUsuario: usuario.uid, nombre: usuario.displayName!),
      sucursalSalida: SucursalVentaModel(
          idSucursal: sucursalSelect, nombre: sucursalSelectName),
      sucursalEntrada: sucursalEntrada,
    );

    traspasoDocument.update(traspasoObjet.toJson());

    var articuloSalidaReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo')
        .where('codigo', isEqualTo: articuloTraspaso.codigo)
        .get();

    var articuloSalidaData = ArticuloTraspasoModel.fromJson(
        articuloSalidaReference.docs.first.data());

    await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo')
        .doc(articuloSalidaData.idArticulo)
        .update({"stock": articuloSalidaData.stock - articuloTraspaso.stock});

    var articuloEntradaReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalEntrada.idSucursal)
        .collection('Articulo')
        .where('codigo', isEqualTo: articuloTraspaso.codigo)
        .get();

    var articuloEntradaData = ArticuloTraspasoModel.fromJson(
        articuloEntradaReference.docs.first.data());

    await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalEntrada.idSucursal)
        .collection('Articulo')
        .doc(articuloEntradaData.idArticulo)
        .update({"stock": articuloEntradaData.stock + articuloTraspaso.stock});

    _pantallaActiva = 0;
    getTraspasos();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getTraspasos() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    _traspasos = [];

    var fechahoy = DateTime.now();

    var fechahoyMin =
        DateTime(fechahoy.year, fechahoy.month, fechahoy.day, 0, 0, 0, 0, 0);
    var fechahoyMax = fechahoyMin;
    fechahoyMax =
        fechahoyMax.add(const Duration(hours: 23, minutes: 59, seconds: 59));

    var traspasoReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Traspaso')
        .get();

    for (var element in traspasoReference.docs) {
      _traspasos.add(TraspasoModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelarTraspaso(String idTraspaso) async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    var traspasoReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Traspaso')
        .doc(idTraspaso);

    traspasoReference.update({'estado': false});

    var traspasoDoc = await traspasoReference.get();

    TraspasoModel traspasoData = TraspasoModel.fromJson(traspasoDoc.data()!);

    var articuloSalidaReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(traspasoData.sucursalSalida.idSucursal)
        .collection('Articulo')
        .where('codigo', isEqualTo: articuloTraspaso.codigo)
        .get();

    var articuloSalidaData = ArticuloTraspasoModel.fromJson(
        articuloSalidaReference.docs.first.data());

    await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(traspasoData.sucursalSalida.idSucursal)
        .collection('Articulo')
        .doc(articuloSalidaData.idArticulo)
        .update({"stock": articuloSalidaData.stock + articuloTraspaso.stock});

    var articuloEntradaReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(traspasoData.sucursalEntrada.idSucursal)
        .collection('Articulo')
        .where('codigo', isEqualTo: articuloTraspaso.codigo)
        .get();

    var articuloEntradaData = ArticuloTraspasoModel.fromJson(
        articuloEntradaReference.docs.first.data());

    await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(traspasoData.sucursalEntrada.idSucursal)
        .collection('Articulo')
        .doc(articuloEntradaData.idArticulo)
        .update({"stock": articuloEntradaData.stock - articuloTraspaso.stock});

    getTraspasos();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReporte({bool buscar = false}) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawString(
        'Traspasos', PdfStandardFont(PdfFontFamily.helvetica, 25),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 50));

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 7);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Sucursal Salida';
    headerRow.cells[1].value = 'Sucursal Entrada';
    headerRow.cells[2].value = 'Usuario';
    headerRow.cells[3].value = 'Articulo';
    headerRow.cells[4].value = 'Cantidad';
    headerRow.cells[5].value = 'Codigo';
    headerRow.cells[6].value = 'Estado';

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

    List<TraspasoModel> traspasosReporte = _traspasos;

    if (buscar == true) traspasosReporte = _traspasosBuscar;

    for (int i = 0; i < traspasosReporte.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = traspasosReporte[i].sucursalSalida.nombre;
      row.cells[1].value = traspasosReporte[i].sucursalEntrada.nombre;
      row.cells[2].value = traspasosReporte[i].usuario.nombre;
      row.cells[3].value = traspasosReporte[i].articulo.nombre;
      row.cells[4].value = traspasosReporte[i].articulo.stock.toString();
      row.cells[5].value = traspasosReporte[i].articulo.codigo;
      row.cells[6].value =
          traspasosReporte[i].estado ? 'Aceptado' : 'Cancelado';
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

    if (await File('${appDocDir.path}/Traspasos.pdf').exists()) {
      await File('${appDocDir.path}/Traspasos.pdf').delete();
    }

    File('${appDocDir.path}/Traspasos.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Traspasos.pdf');

    document.dispose();
  }

  void buscarTraspasos() {
    _traspasosBuscar = [];
    for (var element in _traspasos) {
      var sSalida = element.sucursalSalida.nombre
          .toLowerCase()
          .contains(buscar.text.toLowerCase());
      var sEntrada = element.sucursalEntrada.nombre
          .toLowerCase()
          .contains(buscar.text.toLowerCase());
      var usuario = element.usuario.nombre
          .toLowerCase()
          .contains(buscar.text.toLowerCase());
      var articulo = element.articulo.nombre
          .toLowerCase()
          .contains(buscar.text.toLowerCase());
      var codigo = element.articulo.codigo
          .toLowerCase()
          .contains(buscar.text.toLowerCase());

      var cantidad = int.tryParse(buscar.text);

      if (sSalida ||
          sEntrada ||
          usuario ||
          articulo ||
          codigo ||
          (cantidad == null
              ? false
              : double.parse(buscar.text) == element.articulo.stock) ||
          (buscar.text.toLowerCase() == 'Aceptado'.toLowerCase() &&
              element.estado) ||
          buscar.text.toLowerCase() == 'Cancelado'.toLowerCase() &&
              !element.estado) {
        _traspasosBuscar.add(element);
      }
    }
  }
}
