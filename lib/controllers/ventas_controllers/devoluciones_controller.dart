import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';

class DevolucionesController extends ChangeNotifier {
  bool _isLoading = false;
  String _clienteSelect = '';
  String _comprobante = 'Devolución';

  List<PersonaModel> _clientesAcvtivos = [];
  List<ArticuloModel> _articulosAcvtivos = [];
  List<ArticuloModel> _articulosVenta = [];
  List<ArticuloVentaFormController> _articulosFormVenta = [];

  // List<CategoriaModel> _categorias = [];
  // List<CategoriaModel> _categoriasBuscar = [];

  final UserPreferencesSecure _userPreferences = UserPreferencesSecure();

  bool get isLoading => _isLoading;

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

  List<PersonaModel> get clientesActivos => _clientesAcvtivos;
  List<ArticuloModel> get articulosActivos => _articulosAcvtivos;

  List<ArticuloModel> get articulosDevolucion => _articulosVenta;
  set articulosDevolucion(List<ArticuloModel> value) {
    _articulosVenta = value;
    notifyListeners();
  }

  List<ArticuloVentaFormController> get articulosFormVenta =>
      _articulosFormVenta;
  set articulosFormVenta(List<ArticuloVentaFormController> value) {
    _articulosFormVenta = value;
    notifyListeners();
  }

  void addArticuloDevolucion(ArticuloModel articulo) {
    DevolucionFormController formController = DevolucionFormController();

    double cantidad = double.tryParse(formController.cantidad.text) ?? 1;
    if (cantidad == 0) {
      cantidad = 1;
    }

    for (int i = 0; i < articulosDevolucion.length; i++) {
      if (articulo.codigo == articulosDevolucion[i].codigo) {
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

  void quitarArticuloDevolucion(String id) {
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
    DevolucionFormController formController = DevolucionFormController();
    double total = 0;

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

    formController.cambio.text = (total + impuesto).toStringAsFixed(2);
  }

  void removeArticuloDevolucion(String id) {
    for (int i = 0; i < articulosDevolucion.length; i++) {
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
        .get();

    for (var element in articulosReference.docs) {
      _articulosAcvtivos.add(ArticuloModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarDevolucion() async {
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

    DevolucionFormController formController = DevolucionFormController();

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
        cantidad: double.parse(_articulosFormVenta[i].cantidad.text),
        precioVenta: double.parse(_articulosFormVenta[i].precioVenta.text),
        descuento: double.parse(_articulosFormVenta[i].descuento.text),
        subtotal: double.parse(_articulosFormVenta[i].subtotal.text),
        codigo: _articulosVenta[i].codigo,
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
      totalVenta: double.parse(formController.totalCuenta.text) * (-1),
      numeroComprobante: formController.nVenta.text,
      tipoComprobante: formController.comprobante,
      activo: true,
      idVenta: formController.idventa,
      usuario: usuario,
      sucursal: sucursal,
    );
    await documetReference.update(venta.toJson());

    _userPreferences.setNumVenta((await _userPreferences.getNumVenta()) + 1);
    formController.nVenta.text =
        (await _userPreferences.getNumVenta()).toString();

    for (var element in detalle) {
      await actualizarArticulo(element.idArticulo, element.cantidad);
    }

    limpiarFormulario();
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

    articulosReference.update({"stock": articulo.stock + cantidad});
  }

  Future<void> limpiarFormulario() async {
    DevolucionFormController formController = DevolucionFormController();

    String nombreTienda = await _userPreferences.getNombreTienda();
    String nombreSucursal = await _userPreferences.getNombreSucursal();
    var numeroVenta = await _userPreferences.getNumVenta();
    formController.limpiarFormulario(numeroVenta.toString());

    _articulosVenta = [];
    _articulosFormVenta = [];

    formController.serie.text =
        '${nombreTienda.substring(0, 3)}${nombreTienda.substring(nombreTienda.length - 1)}-${nombreSucursal.substring(0, 3)}${nombreSucursal.substring(nombreSucursal.length - 1)}';
  }
}
