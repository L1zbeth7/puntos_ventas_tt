// To parse this JSON data, do
//
//     final AjusteModel = AjusteModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

AjusteModel ajusteModelFromJson(String str) =>
    AjusteModel.fromJson(json.decode(str));

String ajusteModelToJson(AjusteModel data) => json.encode(data.toJson());

class AjusteModel {
  AjusteModel({
    required this.articulo,
    required this.descripcion,
    required this.idAjuste,
    required this.precioVenta,
    required this.stock,
    this.precioVenta2 = 0,
    this.stock2 = 0,
    required this.usuario,
    required this.fecha,
  });

  ArticuloAjuste articulo;
  String descripcion;
  String idAjuste;
  double precioVenta;
  double stock;
  double precioVenta2;
  double stock2;
  UsuarioAjuste usuario;
  Timestamp fecha;

  factory AjusteModel.fromRawJson(String str) =>
      AjusteModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AjusteModel.fromJson(Map<String, dynamic> json) => AjusteModel(
        articulo: ArticuloAjuste.fromJson(json["articulo"]),
        descripcion: json["descripcion"],
        idAjuste: json["idAjuste"],
        precioVenta: json["precioVenta"].toDouble(),
        stock: json["stock"].toDouble(),
        precioVenta2: (json["precioVenta2"] ?? 0).toDouble(),
        stock2: (json["stock2"] ?? 0).toDouble(),
        usuario: UsuarioAjuste.fromJson(json["usuario"]),
        fecha: json["fecha"],
      );

  Map<String, dynamic> toJson() => {
        "articulo": articulo.toJson(),
        "descripcion": descripcion,
        "idAjuste": idAjuste,
        "precioVenta": precioVenta2,
        "stock": stock2,
        "usuario": usuario.toJson(),
        "fecha": fecha,
      };
}

class ArticuloAjuste {
  ArticuloAjuste({
    required this.idArticulo,
    required this.nombreArticulo,
  });

  String idArticulo;
  String nombreArticulo;

  factory ArticuloAjuste.fromJson(Map<String, dynamic> json) => ArticuloAjuste(
        idArticulo: json["idArticulo"],
        nombreArticulo: json["nombreArticulo"],
      );

  Map<String, dynamic> toJson() => {
        "idArticulo": idArticulo,
        "nombreArticulo": nombreArticulo,
      };
}

class UsuarioAjuste {
  UsuarioAjuste({
    required this.idUsuario,
    required this.nombre,
  });

  String idUsuario;
  String nombre;

  factory UsuarioAjuste.fromJson(Map<String, dynamic> json) => UsuarioAjuste(
        idUsuario: json["idUsuario"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "nombre": nombre,
      };
}
