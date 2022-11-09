import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/models/models.dart';

class ArticuloFormController {
  static final ArticuloFormController _instancia =
      ArticuloFormController._internal();

  factory ArticuloFormController() {
    return _instancia;
  }

  ArticuloFormController._internal();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController idArticulo = TextEditingController();
  TextEditingController idCategoria = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController precioVenta = TextEditingController();
  String imagen = '';
  TextEditingController codigo = TextEditingController();
  bool activo = true;

  TextEditingController buscar = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;

  bool get isValidForm => formKey.currentState?.validate() ?? false;

  void limpiarFormulario() {
    idArticulo.text = '';
    nombre.text = '';
    idCategoria.text = '';
    descripcion.text = '';
    stock.text = '';
    precioVenta.text = '';
    imagen = '';
    codigo.text = '';
    activo = true;
  }

  void llenarFormulario(ArticuloModel articulo) {
    idArticulo.text = articulo.idArticulo;
    nombre.text = articulo.nombre;
    idCategoria.text = '0';
    descripcion.text = articulo.descripcion;
    stock.text = articulo.stock.toString();
    precioVenta.text = articulo.precioVenta.toString();
    imagen = articulo.imagen;
    codigo.text = articulo.codigo;
    activo = articulo.activo;
  }

  Map<String, dynamic> toJson(CategoriaModel categoria, String urlimagen) =>
      ArticuloModel(
        idArticulo: idArticulo.text,
        codigo: codigo.text,
        categoria: categoria,
        imagen: urlimagen,
        stock: double.parse(stock.text),
        precioVenta: double.parse(precioVenta.text),
        nombre: nombre.text,
        activo: activo,
        descripcion: descripcion.text,
      ).toJson();
}
