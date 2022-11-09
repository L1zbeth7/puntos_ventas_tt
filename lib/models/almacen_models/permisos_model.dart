// To parse this JSON data, do
//
//     final categoriaModel = categoriaModelFromJson(jsonString);

import 'dart:convert';

PermisosModel permisosModelFromJson(String str) =>
    PermisosModel.fromJson(json.decode(str));

String permisosModelToJson(PermisosModel data) => json.encode(data.toJson());

class PermisosModel {
  PermisosModel({
    required this.escritorio,
    required this.almacen,
    required this.compras,
    required this.ventas,
    required this.acceso,
    required this.consultaCompras,
    required this.consultaVentas,
  });

  bool acceso;
  bool almacen;
  bool compras;
  bool consultaCompras;
  bool consultaVentas;
  bool escritorio;
  bool ventas;

  factory PermisosModel.fromRawJson(String str) =>
      PermisosModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PermisosModel.fromJson(Map<String, dynamic> json) => PermisosModel(
        acceso: json["Acceso"],
        almacen: json["Almacen"],
        compras: json["Compras"],
        consultaCompras: json["Consulta Compras"],
        consultaVentas: json["Consulta Ventas"],
        escritorio: json["Escritorio"],
        ventas: json["Ventas"],
      );

  Map<String, dynamic> toJson() => {
        "Acceso": acceso,
        "Almacen": almacen,
        "Compras": compras,
        "Consulta Compras": consultaCompras,
        "Consulta Ventas": consultaVentas,
        "Escritorio": escritorio,
        "Ventas": ventas,
      };
}
