// To parse this JSON data, do
//
//     final articuloTraspasoModel = articuloTraspasoModelFromJson(jsonString);

import 'dart:convert';

class ArticuloTraspasoModel {
  ArticuloTraspasoModel({
    required this.idArticulo,
    required this.codigo,
    required this.nombre,
    required this.stock,
  });

  String idArticulo;
  String codigo;
  String nombre;
  int stock;

  factory ArticuloTraspasoModel.fromRawJson(String str) =>
      ArticuloTraspasoModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArticuloTraspasoModel.fromJson(Map<String, dynamic> json) =>
      ArticuloTraspasoModel(
        idArticulo: json["idArticulo"],
        codigo: json["codigo"],
        nombre: json["nombre"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "idArticulo": idArticulo,
        "codigo": codigo,
        "nombre": nombre,
        "stock": stock,
      };
}
