import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IngresoFormController {
  static final IngresoFormController _instancia =
      IngresoFormController._internal();

  factory IngresoFormController() {
    return _instancia;
  }

  IngresoFormController._internal();
  final _format = DateFormat("yyyy-MM-dd");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyIngreso = GlobalKey<FormState>();

  String idventa = '';

  String proveedorSeleccionado = '';
  TextEditingController fecha = TextEditingController();
  String comprobante = 'Ticket';
  TextEditingController serie = TextEditingController();
  TextEditingController nVenta = TextEditingController();
  TextEditingController impuesto = TextEditingController(text: '0');

  TextEditingController cantidad = TextEditingController(text: '1');

  TextEditingController totalCuenta = TextEditingController(text: '0');
  TextEditingController recibe = TextEditingController();
  TextEditingController cambio = TextEditingController(text: '0');

  TextEditingController buscar = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;
  bool get isValidForm => _formKey.currentState?.validate() ?? false;

  GlobalKey<FormState> get formKeyIngreso => _formKeyIngreso;
  bool get isValidFormVenta =>
      _formKeyIngreso.currentState?.validate() ?? false;

  toJson(int idusuiario, int idsucursal) {
    return {
      'idcliente': proveedorSeleccionado.toString(),
      'idusuario': idusuiario.toString(),
      'tipo_comprobante': comprobante,
      'serie': serie.text,
      'num_comprobante': nVenta.text,
      'impuesto': impuesto.text,
      'total_venta': totalCuenta.text,
      'idsucursal': idsucursal.toString()
    };
  }

  void limpiarFormulario() {
    serie.text = '';
    nVenta.text = '';
    idventa = '';
    buscar.text = '';
    cantidad.text = '1';
    totalCuenta.text = '0';
    recibe.text = '0';
    cambio.text = '0';
    impuesto.text = '0';
    fecha.text = _format.format(DateTime.now());
    comprobante = 'Ticket';
  }
}
