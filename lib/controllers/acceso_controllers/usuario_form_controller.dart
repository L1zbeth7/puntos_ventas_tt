import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/models/models.dart';

class UsuarioFormController {
  static final UsuarioFormController _instancia =
      UsuarioFormController._internal();

  factory UsuarioFormController() {
    return _instancia;
  }

  UsuarioFormController._internal();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController idTlati = TextEditingController();
  TextEditingController idUsuario = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController contacto1 = TextEditingController();
  TextEditingController contacto2 = TextEditingController();
  TextEditingController cargo = TextEditingController();

  TextEditingController buscar = TextEditingController();

  Map<String, bool> permisosController = {
    "Escritorio": false,
    "Almacen": false,
    "Acceso": false,
    "Compras": false,
    "Ventas": false,
    "Consulta Compras": false,
    "Consulta Ventas": false,
  };

  GlobalKey<FormState> get formKey => _formKey;

  bool get isValidForm => formKey.currentState?.validate() ?? false;

  void limpiarFormulario() {
    nombre.text = '';
    contacto1.text = ' ';
    contacto2.text = ' ';
  }

  void limpiarFormularioCompleto() {
    idTlati.text = '';
    nombre.text = '';
    contacto1.text = ' ';
    contacto2.text = ' ';
    cargo.text = '';
    permisosController.forEach((key, value) {
      permisosController[key] = false;
    });
  }

  Map<String, dynamic> toJson({
    required Map<SucursalModel, bool> sucursales,
  }) {
    Map<String, dynamic> sucursalesPermisos = {};

    sucursales.forEach((key, value) {
      if (value) {
        sucursalesPermisos.addAll({key.idSucursal: key.toJson()});
      }
    });

    return {
      'Permisos': permisosController,
      'Sucursales': sucursalesPermisos,
      'idTlati': idTlati.text,
      'idUsuario': idUsuario.text,
      'nombre': nombre.text,
      'contacto1': contacto1.text,
      'contacto2': contacto2.text,
      'cargo': cargo.text,
    };
  }
}
