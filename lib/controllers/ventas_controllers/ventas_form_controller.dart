import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VentasFormController {
  static final VentasFormController _instancia =
      VentasFormController._internal();

  factory VentasFormController() {
    return _instancia;
  }

  VentasFormController._internal();
  final _format = DateFormat("yyyy-MM-dd");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyVenta = GlobalKey<FormState>();

  String idventa = '';

  String clienteSeleccionado = '';
  TextEditingController fecha = TextEditingController();
  String comprobante = 'Ticket';
  TextEditingController serie = TextEditingController(text: '');
  TextEditingController nVenta = TextEditingController(text: '1');
  TextEditingController impuesto = TextEditingController(text: '0');

  TextEditingController cantidad = TextEditingController(text: '1');

  TextEditingController totalCuenta = TextEditingController(text: '0');
  TextEditingController recibe = TextEditingController();
  TextEditingController cambio = TextEditingController(text: '0');

  TextEditingController buscar = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;
  bool get isValidForm => _formKey.currentState?.validate() ?? false;

  GlobalKey<FormState> get formKeyVenta => _formKeyVenta;
  bool get isValidFormVenta => _formKeyVenta.currentState?.validate() ?? false;

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

  void limpiarFormulario() {
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

  // insertarVenta(VentaModel venta) {
  //   idventa = venta.idventa;
  //   clienteSeleccionado = venta.idcliente;
  //   fecha.text = venta.fecha.toString();
  //   comprobante = venta.tipoComprobante;
  //   serie.text = venta.serieComprobante;
  //   nVenta.text = venta.numComprobante;

  //   totalCuenta.text = venta.totalVenta.toString();
  // }
}
