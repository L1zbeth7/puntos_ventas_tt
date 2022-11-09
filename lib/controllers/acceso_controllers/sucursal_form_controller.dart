import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/models/models.dart';

class SucursalFormController {
  static final SucursalFormController _instancia =
      SucursalFormController._internal();

  factory SucursalFormController() {
    return _instancia;
  }

  SucursalFormController._internal();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController idsucursal = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController direccion = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController correo = TextEditingController();

  TextEditingController buscar = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;

  bool get isValidForm => formKey.currentState?.validate() ?? false;

  void limpiarFormulario() {
    idsucursal.text = '';
    nombre.text = '';
    direccion.text = '';
    telefono.text = '';
    correo.text = '';
  }

  void llenarFormulario(SucursalModel sucursal) {
    idsucursal.text = sucursal.idSucursal;
    nombre.text = sucursal.nombre;
    direccion.text = sucursal.direccion;
    telefono.text = sucursal.telefono;
    correo.text = sucursal.email;
  }

  Map<String, dynamic> get toJson => SucursalModel(
          nombre: nombre.text,
          direccion: direccion.text,
          telefono: telefono.text,
          email: correo.text,
          idSucursal: idsucursal.text)
      .toJson();
}
