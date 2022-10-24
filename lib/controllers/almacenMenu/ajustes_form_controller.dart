import 'package:flutter/material.dart';

class AjusteFormController {
  static final AjusteFormController _instancia =
      AjusteFormController._internal();

  factory AjusteFormController() {
    return _instancia;
  }

  AjusteFormController._internal();

  TextEditingController idUsuario = TextEditingController();
  TextEditingController nombreUsuario = TextEditingController();
  TextEditingController nombreArticulo = TextEditingController();
  TextEditingController idArticulo = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  double stock = 0;
  double precioVenta = 0;
  TextEditingController stock2 = TextEditingController();
  TextEditingController precioVenta2 = TextEditingController();

  TextEditingController buscar = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  bool get isValidForm => formKey.currentState?.validate() ?? false;

  void llenarFormulario({
    required String idUsuarioA,
    required String nombreUsuarioA,
    required String idArticuloA,
    required String nombreArticuloA,
    required double stockActual,
    required double precioActual,
  }) {
    idUsuario.text = idUsuarioA;
    nombreUsuario.text = nombreUsuarioA;
    nombreArticulo.text = nombreArticuloA;
    idArticulo.text = idArticuloA;
    stock = stockActual;
    precioVenta = precioActual;
    stock2.text = stockActual.toString();
    precioVenta2.text = precioActual.toString();
    descripcion.text = '';
  }
}
