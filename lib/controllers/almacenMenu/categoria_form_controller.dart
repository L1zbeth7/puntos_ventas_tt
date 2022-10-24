import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/models/models.dart';

class CategoriaFormController {
  static final CategoriaFormController _instancia =
      CategoriaFormController._internal();

  factory CategoriaFormController() {
    return _instancia;
  }

  CategoriaFormController._internal();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController idcategoria = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController porcentaje = TextEditingController(text: '0');
  TextEditingController buscar = TextEditingController();

  bool activo = true;

  GlobalKey<FormState> get formKey => _formKey;

  bool get isValidForm => formKey.currentState?.validate() ?? false;

  void limpiarFormulario() {
    idcategoria.text = '';
    nombre.text = '';
    descripcion.text = '';
    porcentaje.text = '0';
    buscar.text = '';
    activo = true;
  }

  void llenarFormulario(CategoriaModel categoria) {
    activo = categoria.activo;
    descripcion.text = categoria.descripcion;
    idcategoria.text = categoria.idCategoria;
    nombre.text = categoria.nombre;
    porcentaje.text = '${categoria.porcentaje}';
  }

  Map<String, dynamic> get toJson => CategoriaModel(
        activo: activo,
        descripcion: descripcion.text,
        idCategoria: idcategoria.text,
        nombre: nombre.text,
        porcentaje: int.parse(porcentaje.text),
      ).toJson();
}
