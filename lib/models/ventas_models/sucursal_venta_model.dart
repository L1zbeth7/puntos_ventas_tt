import 'dart:convert';

class SucursalVentaModel {
  SucursalVentaModel({
    required this.idSucursal,
    required this.nombre,
  });

  String idSucursal;
  String nombre;

  factory SucursalVentaModel.fromRawJson(String str) =>
      SucursalVentaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SucursalVentaModel.fromJson(Map<String, dynamic> json) =>
      SucursalVentaModel(
        idSucursal: json["idSucursal"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "idSucursal": idSucursal,
        "nombre": nombre,
      };
}
