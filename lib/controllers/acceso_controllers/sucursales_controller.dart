import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class SucursalesController extends ChangeNotifier {
  bool _isLoading = false;
  int _pantallaActiva = 0;
  bool _valorSwitch = true;
  bool _buscarVacio = true;

  List<SucursalModel> _sucursales = [];
  List<SucursalModel> _sucursalesBuscar = [];

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
    CategoriaFormController formController = CategoriaFormController();
    if (value) formController.buscar.text = '';
    _buscarVacio = value;
    notifyListeners();
  }

  List<SucursalModel> get sucursales => _sucursales;
  List<SucursalModel> get sucursalesBuscar => _sucursalesBuscar;

  Future<void> getSucursales() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();

    _sucursales = [];

    var categoriasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .get();

    for (var element in categoriasReference.docs) {
      _sucursales.add(SucursalModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarEditarSucursal() async {
    _isLoading = true;
    notifyListeners();

    SucursalFormController formController = SucursalFormController();

    String tiendaSelect = await _userPreferences.getTiendaId();

    var sucursalReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal');

    if (formController.idsucursal.text == '') {
      var documetReference = await sucursalReference.add({});
      formController.idsucursal.text = documetReference.id;
      await documetReference.update(formController.toJson);

      var categoriaReference = FirebaseFirestore.instance
          .collection('Punto-Venta')
          .doc(tiendaSelect)
          .collection('Sucursal')
          .doc(documetReference.id)
          .collection('Categoria');

      var documetCategoriaReference = await categoriaReference.add({});
      var idCategoria = documetCategoriaReference.id;
      await documetCategoriaReference.update(CategoriaModel(
              activo: true,
              descripcion: 'Venta de producto agranel',
              idCategoria: idCategoria,
              nombre: 'Agranel',
              porcentaje: 1)
          .toJson());
    } else {
      await sucursalReference
          .doc(formController.idsucursal.text)
          .update(formController.toJson);
    }

    formController.limpiarFormulario();
    _pantallaActiva = 0;
    _valorSwitch = true;

    getSucursales();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> eliminarCategoria(String idCategoria) async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();
    var categoriasReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Categoria');

    await categoriasReference.doc(idCategoria).delete();

    getSucursales();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReporte({bool buscar = false}) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawString(
        'Sucursales', PdfStandardFont(PdfFontFamily.helvetica, 25),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 50));

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 4);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Nombre';
    headerRow.cells[1].value = 'Dirección';
    headerRow.cells[2].value = 'Teléfono';
    headerRow.cells[3].value = 'Correo';

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

    List<SucursalModel> sucursalesReporte = _sucursales;

    if (buscar == true) sucursalesReporte = _sucursalesBuscar;

    for (int i = 0; i < sucursalesReporte.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = sucursalesReporte[i].nombre;
      row.cells[1].value = sucursalesReporte[i].direccion;
      row.cells[2].value = sucursalesReporte[i].telefono;
      row.cells[3].value = sucursalesReporte[i].email;
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

    if (await File('${appDocDir.path}/Sucursales.pdf').exists()) {
      await File('${appDocDir.path}/Sucursales.pdf').delete();
    }

    File('${appDocDir.path}/Sucursales.pdf')
        .writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Sucursales.pdf');

    document.dispose();
  }

  void buscarSucursal() {
    SucursalFormController formController = SucursalFormController();
    _sucursalesBuscar = [];
    for (var element in _sucursales) {
      var nombre = element.nombre
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var direccion = element.direccion
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var telefono = element.telefono
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var correo = element.email
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());

      if (nombre || direccion || telefono || correo) {
        _sucursalesBuscar.add(element);
      }
    }
  }
}
