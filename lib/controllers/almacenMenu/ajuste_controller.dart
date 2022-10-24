import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/controllers/almacenMenu/ajustes_form_controller.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/colores.dart';
import 'package:puntos_ventas_tt/utils/user_preferences_secure.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class AjusteController extends ChangeNotifier {
  bool _isLoading = true;
  bool _buscarVacio = true;

  List<AjusteModel> _ajustes = [];
  List<AjusteModel> _ajustesBuscar = [];

  final _format = DateFormat("yyyy-MM-dd HH:mm:ss");

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get buscarVacio => _buscarVacio;

  set buscarVacio(bool value) {
    AjusteFormController formController = AjusteFormController();
    if (value) formController.buscar.text = '';
    _buscarVacio = value;
    notifyListeners();
  }

  List<AjusteModel> get ajustes => _ajustes;
  List<AjusteModel> get ajustesBuscar => _ajustesBuscar;

  final UserPreferencesSecure _userPreferences = UserPreferencesSecure();

  getAjustes() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    _ajustes = [];

    var ajusteReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Ajuste')
        .get();

    for (var element in ajusteReference.docs) {
      _ajustes.add(AjusteModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReporte({bool buscar = false}) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawString(
        'Ajuste', PdfStandardFont(PdfFontFamily.helvetica, 25),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 50));

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 6);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Nombre Articulo';
    headerRow.cells[1].value = 'Nombre Usuario';
    headerRow.cells[2].value = 'Descripcion';
    headerRow.cells[3].value = 'Stock';
    headerRow.cells[4].value = 'Precio Venta';
    headerRow.cells[5].value = 'Fecha';

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

    List<AjusteModel> ajustesReporte = _ajustes;

    if (buscar == true) ajustesReporte = _ajustesBuscar;

    for (int i = 0; i < ajustesReporte.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = ajustesReporte[i].articulo.nombreArticulo;
      row.cells[1].value = ajustesReporte[i].usuario.nombre;
      row.cells[2].value = ajustesReporte[i].descripcion;
      row.cells[3].value = ajustesReporte[i].stock.toString();
      row.cells[4].value = ajustesReporte[i].precioVenta.toString();
      row.cells[5].value = _format.format(ajustesReporte[i].fecha.toDate());
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

    if (await File('${appDocDir.path}/Ajustes.pdf').exists()) {
      await File('${appDocDir.path}/Ajustes.pdf').delete();
    }

    File('${appDocDir.path}/Ajustes.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Ajustes.pdf');

    document.dispose();
  }

  void buscarAjustes() {
    AjusteFormController formController = AjusteFormController();
    _ajustesBuscar = [];
    for (var element in _ajustes) {
      var nombreA = element.articulo.nombreArticulo
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var nombreU = element.usuario.nombre
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var descripcion = element.descripcion
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var stock = int.tryParse(formController.buscar.text);
      var precio = int.tryParse(formController.buscar.text);

      var fecha = _format
          .format(element.fecha.toDate())
          .contains(formController.buscar.text);

      if (nombreA ||
          nombreU ||
          descripcion ||
          (stock == null
              ? false
              : int.parse(formController.buscar.text) == element.stock) ||
          (precio == null
              ? false
              : int.parse(formController.buscar.text) == element.precioVenta) ||
          fecha) {
        _ajustesBuscar.add(element);
      }
    }
  }
}
