// To parse this JSON data, do
//
//     final proveedorModel = proveedorModelFromJson(jsonString);

import 'dart:convert';

class ProveedorModel {
  ProveedorModel({
    required this.nombre,
    required this.idCliente,
  });

  String nombre;
  String idCliente;

  factory ProveedorModel.fromRawJson(String str) =>
      ProveedorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProveedorModel.fromJson(Map<String, dynamic> json) => ProveedorModel(
        nombre: json["nombre"],
        idCliente: json["idCliente"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "idCliente": idCliente,
      };
}
