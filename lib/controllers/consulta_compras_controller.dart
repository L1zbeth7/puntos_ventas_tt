import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ConsultaComprasController extends ChangeNotifier {
  bool _isLoading = false;
  int _pantallaActiva = 0;
  bool _buscarVacio = true;

  DateTime _fechaInicial = DateTime.now();
  DateTime _fechaFinal = DateTime.now();

  List<IngresoModel> _ingresos = [];
  List<IngresoModel> _ingresosBuscar = [];

  final UserPreferencesSecure _userPreferences = UserPreferencesSecure();

  final _format = DateFormat("yyyy-MM-dd hh:mm:ss");

  TextEditingController fechaInicio = TextEditingController();
  TextEditingController fechaFin = TextEditingController();
  TextEditingController buscar = TextEditingController();

  bool get isLoading => _isLoading;

  int get pantallaActiva => _pantallaActiva;
  set pantallaActiva(int value) {
    _pantallaActiva = value;
    notifyListeners();
  }

  bool get buscarVacio => _buscarVacio;
  set buscarVacio(bool value) {
    _buscarVacio = value;
    notifyListeners();
  }

  DateTime get fechaInicial => _fechaInicial;
  set fechaInicial(DateTime value) {
    _fechaInicial = value;
    notifyListeners();
  }

  DateTime get fechaFinal => _fechaFinal;
  set fechaFinal(DateTime value) {
    _fechaFinal = value;
    notifyListeners();
  }

  List<IngresoModel> get ingresos => _ingresos;
  List<IngresoModel> get ingresosBuscar => _ingresosBuscar;

  Future<void> getCompras() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    _ingresos = [];

    var fechaMin = DateTime(
        fechaInicial.year, fechaInicial.month, fechaInicial.day, 0, 0, 0, 0, 0);
    var fechaMax = DateTime(fechaFinal.year, fechaFinal.month, fechaFinal.day,
        23, 59, 60, 999, 999);

    var ventasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Ingreso')
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(fechaMin))
        .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fechaMax))
        .orderBy('fecha', descending: true)
        .get();

    for (var element in ventasReference.docs) {
      _ingresos.add(IngresoModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  void reiniciarFechas() {
    final format = DateFormat("yyyy-MM-dd");
    var fechaHoy = DateTime.now();
    _fechaInicial = DateTime(fechaHoy.year, fechaHoy.month, 1);
    _fechaFinal = fechaHoy;
    fechaInicio.text = format.format(_fechaInicial);
    fechaFin.text = format.format(fechaHoy);
    buscar.text = '';
    _buscarVacio = true;
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

    double suma = 0;

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

      suma += categoriasReporte[i].totalIngreso;
    }

    PdfGridRow row = grid.rows.add();
    row.cells[4].value = 'Total: ';
    row.cells[5].value = '\$$suma';
    row.style = PdfGridRowStyle(
        backgroundBrush: categoriasReporte.length % 2 != 0
            ? PdfBrushes.white
            : PdfSolidBrush(PdfColor(200, 200, 200)));

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
    _ingresosBuscar = [];
    for (var element in _ingresos) {
      var fecha = _format
          .format(element.fecha.toDate())
          .toLowerCase()
          .contains(buscar.text);

      var proveedor = element.proveedor.nombre
          .toLowerCase()
          .contains(buscar.text.toLowerCase());

      var documento = element.tipoComprobante
          .toLowerCase()
          .contains(buscar.text.toLowerCase());
      var numero = element.numeroComprobante
          .toLowerCase()
          .contains(buscar.text.toLowerCase());
      var serieNumero =
          ('${element.serieComprobante}-${element.numeroComprobante}')
              .toLowerCase()
              .contains(buscar.text.toLowerCase());
      var sucursal = element.sucursal.nombre
          .toLowerCase()
          .contains(buscar.text.toLowerCase());
      var totalVenta = int.tryParse(buscar.text);

      if (fecha ||
          proveedor ||
          documento ||
          numero ||
          serieNumero ||
          sucursal ||
          (totalVenta == null
              ? false
              : int.parse(buscar.text) == element.totalIngreso)) {
        _ingresosBuscar.add(element);
      }
    }
  }
}
