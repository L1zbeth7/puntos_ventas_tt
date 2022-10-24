// To parse this JSON data, do
//
//     final articuloModel = articuloModelFromJson(jsonString);

import 'dart:convert';

import 'package:puntos_ventas_tt/models/almacenMenu/almacen_model.dart';

class ArticuloModel {
  ArticuloModel({
    required this.activo,
    required this.categoria,
    required this.descripcion,
    this.idCategoria,
    required this.nombre,
    this.porcentaje,
    required this.codigo,
    required this.idArticulo,
    required this.imagen,
    required this.precioVenta,
    required this.stock,
  });

  bool activo;
  CategoriaModel categoria;
  String descripcion;
  String? idCategoria;
  String nombre;
  int? porcentaje;
  String codigo;
  String idArticulo;
  String imagen;
  double precioVenta;
  double stock;

  factory ArticuloModel.fromRawJson(String str) =>
      ArticuloModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArticuloModel.fromJson(Map<String, dynamic> json) => ArticuloModel(
        activo: json["activo"],
        categoria: json["categoria"],
        descripcion: json["descripcion"],
        idCategoria: json["idCategoria"],
        nombre: json["nombre"],
        porcentaje: json["porcentaje"],
        codigo: json["codigo"],
        idArticulo: json["idArticulo"],
        imagen: json["imagen"],
        precioVenta: json["precioVenta"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "activo": activo,
        "categoria": categoria,
        "descripcion": descripcion,
        "idCategoria": idCategoria,
        "nombre": nombre,
        "porcentaje": porcentaje,
        "codigo": codigo,
        "idArticulo": idArticulo,
        "imagen": imagen,
        "precioVenta": precioVenta,
        "stock": stock,
      };
}
