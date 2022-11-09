import 'dart:convert';

import 'package:puntos_ventas_tt/models/models.dart';

UsuarioModel userModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String userModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  UsuarioModel({
    required this.idUsuario,
    required this.idTlati,
    required this.cargo,
    required this.nombre,
    this.contacto1,
    this.contacto2,
    this.sucursales,
    this.permisos,
  });

  String idUsuario;
  String idTlati;
  String cargo;
  String nombre;
  String? contacto1;
  String? contacto2;
  Map<SucursalModel, bool>? sucursales;
  PermisosModel? permisos;

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        idUsuario: json["idUsuario"],
        idTlati: json["idTlati"],
        cargo: json["cargo"],
        nombre: json["nombre"],
        contacto1: json["contacto1"],
        contacto2: json["contacto2"],
      );

  Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "idTlati": idTlati,
        "cargo": cargo,
        "nombre": nombre,
        "contacto1": contacto1,
        "contacto2": contacto2,
      };
}
