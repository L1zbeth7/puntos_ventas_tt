import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/controllers/ventas_controllers/cliente_form_controller.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ClientesController extends ChangeNotifier {
  bool _isLoading = false;
  int _pantallaActiva = 0;
  bool _buscarVacio = true;

  List<PersonaModel> _clientes = [];
  List<PersonaModel> _clientesBuscar = [];

  final UserPreferencesSecure _userPreferences = UserPreferencesSecure();

  bool get isLoading => _isLoading;

  int get pantallaActiva => _pantallaActiva;

  set pantallaActiva(int value) {
    _pantallaActiva = value;
    notifyListeners();
  }

  bool get buscarVacio => _buscarVacio;

  set buscarVacio(bool value) {
    ClienteFormController formController = ClienteFormController();
    if (value) formController.buscar.text = '';
    _buscarVacio = value;
    notifyListeners();
  }

  List<PersonaModel> get clientes => _clientes;
  List<PersonaModel> get clientesBuscar => _clientesBuscar;

  Future<void> getClientes() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();

    _clientes = [];

    var categoriasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Cliente')
        .get();
    // .doc(sucursalSelect)
    // .collection('Categoria')

    for (var element in categoriasReference.docs) {
      _clientes.add(PersonaModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarEditarCliente() async {
    _isLoading = true;
    notifyListeners();

    ClienteFormController formController = ClienteFormController();

    String tiendaSelect = await _userPreferences.getTiendaId();

    var clientesReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Cliente');

    if (formController.id.text == '') {
      var documetReference = await clientesReference.add({});
      formController.id.text = documetReference.id;
      await documetReference.update(formController.toJson);
    } else {
      await clientesReference
          .doc(formController.id.text)
          .update(formController.toJson);
    }

    _pantallaActiva = 0;

    getClientes();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> eliminarCliente(String id) async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();

    var provedoresReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Cliente');

    await provedoresReference.doc(id).delete();

    getClientes();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReporte({bool buscar = false}) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawString(
        'Clientes', PdfStandardFont(PdfFontFamily.helvetica, 25),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 50));

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 5);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Nombre';
    headerRow.cells[1].value = 'Documento';
    headerRow.cells[2].value = 'N. Documento';
    headerRow.cells[3].value = 'Telefono';
    headerRow.cells[4].value = 'E-mail';

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

    List<PersonaModel> categoriasReporte = _clientes;

    if (buscar == true) categoriasReporte = _clientesBuscar;

    for (int i = 0; i < categoriasReporte.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = categoriasReporte[i].nombre;
      row.cells[1].value = categoriasReporte[i].documento == '0'
          ? ''
          : categoriasReporte[i].documento;
      row.cells[2].value = categoriasReporte[i].numeroDocumento;
      row.cells[3].value = categoriasReporte[i].telefono;
      row.cells[4].value = categoriasReporte[i].email;
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

    if (await File('${appDocDir.path}/Clientes.pdf').exists()) {
      await File('${appDocDir.path}/Clientes.pdf').delete();
    }

    File('${appDocDir.path}/Clientes.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Clientes.pdf');

    document.dispose();
  }

  void buscarclientes() {
    ClienteFormController formController = ClienteFormController();
    _clientesBuscar = [];
    for (var element in _clientes) {
      var nombre = element.nombre
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var documento = element.documento
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var numeroDocumento = element.numeroDocumento
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var telefono = element.telefono
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var email = element.email
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());

      if (nombre || documento || numeroDocumento || telefono || email) {
        _clientesBuscar.add(element);
      }
    }
  }
}
