import 'package:flutter/material.dart';

class ArticuloIngresoFormController {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController cantidad = TextEditingController();
  TextEditingController precioCompra = TextEditingController();
  TextEditingController descuento = TextEditingController();
  TextEditingController porcentaje = TextEditingController();
  TextEditingController precioVenta = TextEditingController();
  TextEditingController subtotal = TextEditingController();

  GlobalKey get formKey => _formKey;
  bool get isValidForm => _formKey.currentState?.validate() ?? false;

  toJson() {
    return {
      'cantidad': cantidad.text,
      'precioCompra': precioCompra.text,
      'porcentaje': porcentaje.text,
      'precioVenta': precioVenta.text,
      'descuento': descuento.text,
      'subtotal': subtotal.text,
    };
  }
}
