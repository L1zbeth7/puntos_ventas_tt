import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/models/models.dart';

class ProveedorFormController {
  static final ProveedorFormController _instancia =
      ProveedorFormController._internal();

  factory ProveedorFormController() {
    return _instancia;
  }

  ProveedorFormController._internal();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController id = TextEditingController();
  TextEditingController nombre = TextEditingController();
  String tipoDocumento = '0';
  TextEditingController numeroDocumento = TextEditingController();
  TextEditingController direccion = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController buscar = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;

  bool get isValidForm => formKey.currentState?.validate() ?? false;

  void limpiarFormulario() {
    id.text = '';
    nombre.text = '';
    tipoDocumento = '0';
    numeroDocumento.text = '';
    direccion.text = '';
    telefono.text = '';
    email.text = '';
  }

  void llenarFormulario(PersonaModel proveedor) {
    id.text = proveedor.id;
    nombre.text = proveedor.nombre;
    tipoDocumento = proveedor.documento;
    numeroDocumento.text = proveedor.numeroDocumento;
    direccion.text = proveedor.direccion;
    telefono.text = proveedor.telefono;
    email.text = proveedor.email;
  }

  Map<String, dynamic> get toJson => PersonaModel(
          direccion: direccion.text,
          documento: tipoDocumento,
          email: email.text,
          id: id.text,
          nombre: nombre.text,
          numeroDocumento: numeroDocumento.text,
          telefono: telefono.text)
      .toJson();
}
