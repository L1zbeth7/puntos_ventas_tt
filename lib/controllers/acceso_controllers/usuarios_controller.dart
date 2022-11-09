import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class UsuariosController extends ChangeNotifier {
  bool _isLoading = false;
  int _pantallaActiva = 0;
  bool _valorSwitch = true;
  bool _buscarVacio = true;

  Map<String, dynamic> _usuario = {};
  String _imagen = '';

  List<UsuarioModel> _usuarios = [];
  List<UsuarioModel> _usuariosBuscar = [];

  Map<SucursalModel, bool> _sucursales = {};

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
    UsuarioFormController formController = UsuarioFormController();
    if (value) formController.buscar.text = '';
    _buscarVacio = value;
    notifyListeners();
  }

  bool get usuario => _usuario.isEmpty;
  String get imagen => _imagen;
  set imagen(String value) {
    _imagen = value;
    notifyListeners();
  }

  List<UsuarioModel> get usuarios => _usuarios;
  List<UsuarioModel> get usuariosBuscar => _usuariosBuscar;

  Map<SucursalModel, bool> get sucursales => _sucursales;

  Future<void> getUsuario(String idTlati) async {
    UsuarioFormController formController = UsuarioFormController();

    _isLoading = true;
    notifyListeners();
    var usuarioReference = await FirebaseFirestore.instance
        .collection('Drivers')
        .where('idTlati', isEqualTo: idTlati)
        .get();

    if (usuarioReference.docs.isNotEmpty) {
      _usuario = usuarioReference.docs.first.data();
      formController.nombre.text = _usuario["username"];
      _imagen = _usuario["image"];
      if (_usuario["Contacto"] != null) {
        formController.contacto1.text = _usuario["Contacto"]["email"] ?? '';
        formController.contacto2.text = _usuario["Contacto"]["telefono"] ?? '';
      }
      formController.idUsuario.text = _usuario['id'];
    } else {
      formController.limpiarFormulario();
      _usuario = {};
      _imagen = '';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getUsuarioById(String idUsaurio) async {
    UsuarioFormController formController = UsuarioFormController();

    _isLoading = true;
    notifyListeners();
    var usuarioReference = await FirebaseFirestore.instance
        .collection('Drivers')
        .where('id', isEqualTo: idUsaurio)
        .get();

    if (usuarioReference.docs.isNotEmpty) {
      _usuario = usuarioReference.docs.first.data();
      formController.nombre.text = _usuario["username"];
      _imagen = _usuario["image"] ?? '';
      if (_usuario["Contacto"] != null) {
        formController.contacto1.text = _usuario["Contacto"]["email"] ?? '';
        formController.contacto2.text = _usuario["Contacto"]["telefono"] ?? '';
      }
      await getSucursales();

      String tiendaSelect = await _userPreferences.getTiendaId();

      var tiendaReference = await FirebaseFirestore.instance
          .collection('Punto-Venta')
          .doc(tiendaSelect)
          .get();

      var usuarioTienda = tiendaReference.data()!['Usuarios'][idUsaurio];

      Map<String, dynamic> sucursales = usuarioTienda['Sucursales'];

      sucursales.forEach((key, value) {
        _sucursales.forEach((key2, value2) {
          if (key2.idSucursal == key) {
            _sucursales[key2] = true;
          }
        });
      });

      Map<String, dynamic> permisos = usuarioTienda['Permisos'];

      permisos.forEach((key, value) {
        formController.permisosController.forEach((key2, value) {
          if (key2 == key) {
            formController.permisosController[key2] = true;
          }
        });
      });

      formController.cargo.text = usuarioTienda['cargo'];
      formController.idTlati.text = _usuario['idTlati'];

      if (_usuario['idTlati'].contains('T-')) {
        formController.idTlati.text = _usuario['idTlati'].substring(2);
      } else {
        formController.idTlati.text = _usuario['idTlati'];
      }

      // formController.llenarFormulario(sucursal);
    } else {
      formController.limpiarFormulario();
      _usuario = {};
      _imagen = '';
    }

    _isLoading = false;
    notifyListeners();
  }

  void limpiarFormulario() {
    UsuarioFormController formController = UsuarioFormController();
    formController.limpiarFormulario();
    _imagen = '';
    _usuario = {};
    notifyListeners();
  }

  void limpiarFormularioCompelto() {
    UsuarioFormController formController = UsuarioFormController();
    formController.limpiarFormularioCompleto();
    _imagen = '';
    _usuario = {};
    notifyListeners();
  }

  Future<void> getUsuarios() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();

    _usuarios = [];

    var tiendaReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .get();

    Map<String, dynamic> usuariosData = tiendaReference.data()!['Usuarios'];

    usuariosData.forEach((key, value) {
      UsuarioModel usuario = UsuarioModel.fromJson(value);

      Map<String, dynamic> sucursalesData = value['Sucursales'];

      Map<SucursalModel, bool> sucursalesUsuario = {};

      sucursalesData.forEach((key, value) {
        sucursalesUsuario.addAll({SucursalModel.fromJson(value): true});
      });

      usuario.permisos = PermisosModel.fromJson(value['Permisos']);

      _usuarios.add(usuario);
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getSucursales() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();

    _sucursales = {};

    var sucursalesReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .get();
    for (var element in sucursalesReference.docs) {
      _sucursales.addAll({SucursalModel.fromJson(element.data()): false});
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarUsuario() async {
    _isLoading = true;
    notifyListeners();

    UsuarioFormController formController = UsuarioFormController();

    String tiendaSelect = await _userPreferences.getTiendaId();

    var tiendaReference =
        FirebaseFirestore.instance.collection('Punto-Venta').doc(tiendaSelect);

    await tiendaReference.update({
      'Usuarios.${_usuario['id']}':
          formController.toJson(sucursales: _sucursales)
    });

    limpiarFormularioCompelto();
    _pantallaActiva = 0;
    _valorSwitch = true;

    getUsuarios();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> eliminarUsuario(String idUsuario) async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();

    var tiendaReference =
        FirebaseFirestore.instance.collection('Punto-Venta').doc(tiendaSelect);

    tiendaReference.update({'Usuarios.$idUsuario': FieldValue.delete()});

    getUsuarios();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReporte({bool buscar = false}) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawString(
        'Usuarios', PdfStandardFont(PdfFontFamily.helvetica, 25),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 50));

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 4);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Nombre';
    headerRow.cells[1].value = 'Cargo';
    headerRow.cells[2].value = 'Contacto1';
    headerRow.cells[3].value = 'Contacto2';

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

    List<UsuarioModel> categoriasReporte = _usuarios;

    if (buscar == true) categoriasReporte = _usuariosBuscar;

    for (int i = 0; i < categoriasReporte.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = categoriasReporte[i].nombre;
      row.cells[1].value = categoriasReporte[i].cargo;
      row.cells[2].value = categoriasReporte[i].contacto1;
      row.cells[3].value = categoriasReporte[i].contacto2;
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

    if (await File('${appDocDir.path}/Usuarios.pdf').exists()) {
      await File('${appDocDir.path}/Usuarios.pdf').delete();
    }

    File('${appDocDir.path}/Usuarios.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Usuarios.pdf');

    document.dispose();
  }

  void buscarUsuarios() {
    UsuarioFormController formController = UsuarioFormController();
    _usuariosBuscar = [];
    for (var element in _usuarios) {
      var nombre = element.nombre
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var cargo = element.cargo
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var contacto1 = element.contacto1!
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      var contacto2 = element.contacto2!
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());

      if (nombre || cargo || contacto1 || contacto2) {
        _usuariosBuscar.add(element);
      }
    }
  }
}
