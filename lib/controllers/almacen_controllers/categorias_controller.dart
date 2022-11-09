import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CategoriasController extends ChangeNotifier {
  bool _isLoading = false;
  int _pantallaActiva = 0;
  bool _valorSwitch = true;
  bool _buscarVacio = true;

  List<CategoriaModel> _categorias = [];
  List<CategoriaModel> _categoriasBuscar = [];

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

  List<CategoriaModel> get categorias => _categorias;
  List<CategoriaModel> get categoriasBuscar => _categoriasBuscar;

  Future<void> getcategorias() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    _categorias = [];

    var categoriasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Categoria')
        .get();

    for (var element in categoriasReference.docs) {
      _categorias.add(CategoriaModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarEditarCategoria() async {
    _isLoading = true;
    notifyListeners();

    CategoriaFormController formController = CategoriaFormController();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    var categoriasReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Categoria');

    if (formController.idcategoria.text == '') {
      var documetReference = await categoriasReference.add({});
      formController.idcategoria.text = documetReference.id;
      documetReference.update(formController.toJson);
    } else {
      await categoriasReference
          .doc(formController.idcategoria.text)
          .update(formController.toJson);
    }

    formController.limpiarFormulario();
    _pantallaActiva = 0;
    _valorSwitch = true;

    getcategorias();

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

    getcategorias();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReporte({bool buscar = false}) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawString(
        'Categoria', PdfStandardFont(PdfFontFamily.helvetica, 25),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 50));

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 4);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Nombre';
    headerRow.cells[1].value = 'Descripción';
    headerRow.cells[2].value = 'Porcentaje';
    headerRow.cells[3].value = 'Estado';

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

    List<CategoriaModel> categoriasReporte = _categorias;

    if (buscar == true) categoriasReporte = categoriasBuscar;

    for (int i = 0; i < categoriasReporte.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = categoriasReporte[i].nombre;
      row.cells[1].value = categoriasReporte[i].descripcion;
      row.cells[2].value = categoriasReporte[i].porcentaje.toString();
      row.cells[3].value =
          categoriasReporte[i].activo ? 'Activado' : 'Desactivado';
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

    if (await File('${appDocDir.path}/Categorias.pdf').exists()) {
      await File('${appDocDir.path}/Categorias.pdf').delete();
    }

    File('${appDocDir.path}/Categorias.pdf')
        .writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Categorias.pdf');

    document.dispose();
  }

  void buscarCategorias() {
    CategoriaFormController formController = CategoriaFormController();
    _categoriasBuscar = [];
    for (var element in _categorias) {
      var nombre = element.nombre
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var descripcion = element.descripcion
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var porcentaje = int.tryParse(formController.buscar.text);

      if (nombre ||
          descripcion ||
          (porcentaje == null
              ? false
              : int.parse(formController.buscar.text) == element.porcentaje)) {
        _categoriasBuscar.add(element);
      }
    }
  }
}
