// To parse this JSON data, do
//
//     final categoriaModel = categoriaModelFromJson(jsonString);

import 'dart:convert';

class CategoriaModel {
  CategoriaModel({
    required this.activo,
    required this.descripcion,
    required this.idCategoria,
    required this.nombre,
    required this.porcentaje,
  });

  bool activo;
  String descripcion;
  String idCategoria;
  String nombre;
  int porcentaje;

  factory CategoriaModel.fromRawJson(String str) =>
      CategoriaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
        activo: json["activo"],
        descripcion: json["descripcion"],
        idCategoria: json["idCategoria"],
        nombre: json["nombre"],
        porcentaje: json["porcentaje"],
      );

  Map<String, dynamic> toJson() => {
        "activo": activo,
        "descripcion": descripcion,
        "idCategoria": idCategoria,
        "nombre": nombre,
        "porcentaje": porcentaje,
      };
}
