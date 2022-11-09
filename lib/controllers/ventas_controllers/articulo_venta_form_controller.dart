import 'package:flutter/material.dart';

class ArticuloVentaFormController {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController cantidad = TextEditingController();
  TextEditingController precioVenta = TextEditingController();
  TextEditingController descuento = TextEditingController();
  TextEditingController subtotal = TextEditingController();

  GlobalKey get formKey => _formKey;
  bool get isValidForm => _formKey.currentState?.validate() ?? false;

  toJson() {
    return {
      'cantidad': cantidad.text,
      'precioVenta': precioVenta.text,
      'descuento': descuento.text,
      'subtotal': subtotal.text,
    };
  }
}
