import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DevolucionFormController {
  static final DevolucionFormController _instancia =
      DevolucionFormController._internal();

  factory DevolucionFormController() {
    return _instancia;
  }

  DevolucionFormController._internal();
  final _format = DateFormat("yyyy-MM-dd");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDevolucion = GlobalKey<FormState>();

  String idventa = '';

  String clienteSeleccionado = '';
  TextEditingController fecha = TextEditingController();
  String comprobante = 'Devolución';
  TextEditingController serie = TextEditingController(text: '');
  TextEditingController nVenta = TextEditingController(text: '1');
  TextEditingController impuesto = TextEditingController(text: '0');

  TextEditingController cantidad = TextEditingController(text: '1');

  TextEditingController totalCuenta = TextEditingController(text: '0');
  TextEditingController cambio = TextEditingController(text: '0');

  TextEditingController buscar = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;
  bool get isValidForm => _formKey.currentState?.validate() ?? false;

  GlobalKey<FormState> get formKeyDevolucion => _formKeyDevolucion;
  bool get isValidFormDevolucion =>
      _formKeyDevolucion.currentState?.validate() ?? false;

  toJson(int idusuiario, int idsucursal) {
    return {
      'idcliente': clienteSeleccionado.toString(),
      'idusuario': idusuiario.toString(),
      'tipo_comprobante': comprobante,
      'serie': serie.text,
      'num_comprobante': nVenta.text,
      'impuesto': impuesto.text,
      'total_venta': totalCuenta.text,
      'idsucursal': idsucursal.toString()
    };
  }

  void limpiarFormulario(String idVenta) {
    idventa = '';
    cantidad.text = '1';
    totalCuenta.text = '0';
    cambio.text = '0';
    impuesto.text = '0';
    fecha.text = _format.format(DateTime.now());
    comprobante = 'Devolución';
  }
}
