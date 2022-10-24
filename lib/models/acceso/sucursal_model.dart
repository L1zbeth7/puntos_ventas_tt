// To parse this JSON data, do
//
//     final sucrusalModel = sucrusalModelFromJson(jsonString);

import 'dart:convert';

class SucursalModel {
  SucursalModel({
    required this.direccion,
    required this.email,
    required this.idSucursal,
    required this.nombre,
    required this.telefono,
  });

  String direccion;
  String email;
  String idSucursal;
  String nombre;
  String telefono;

  factory SucursalModel.fromRawJson(String str) =>
      SucursalModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SucursalModel.fromJson(Map<String, dynamic> json) => SucursalModel(
        direccion: json["direccion"],
        email: json["email"],
        idSucursal: json["idSucursal"],
        nombre: json["nombre"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "direccion": direccion,
        "email": email,
        "idSucursal": idSucursal,
        "nombre": nombre,
        "telefono": telefono,
      };
}
