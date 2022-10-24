// To parse this JSON data, do
//
//     final articuloVentaModel = articuloVentaModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puntos_ventas_tt/models/almacenMenu/almacen_model.dart';
import 'package:puntos_ventas_tt/models/venta_models/venta_models.dart';

class TraspasoModel {
  TraspasoModel({
    required this.fecha,
    required this.articulo,
    required this.estado,
    required this.idTraspaso,
    required this.usuario,
    required this.sucursalEntrada,
    required this.sucursalSalida,
  });

  Timestamp fecha;
  ArticuloTraspasoModel articulo;
  bool estado;
  String idTraspaso;
  UsuarioVentaModel usuario;
  SucursalVentaModel sucursalEntrada;
  SucursalVentaModel sucursalSalida;

  factory TraspasoModel.fromRawJson(String str) =>
      TraspasoModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TraspasoModel.fromJson(Map<String, dynamic> json) => TraspasoModel(
        fecha: json["fecha"],
        articulo: ArticuloTraspasoModel.fromJson(json['Articulo']),
        estado: json['estado'],
        idTraspaso: json['idTraspaso'],
        usuario: UsuarioVentaModel.fromJson(json["Usuario"]),
        sucursalEntrada: SucursalVentaModel.fromJson(json['SucursalEntrada']),
        sucursalSalida: SucursalVentaModel.fromJson(json['SucursalSalida']),
      );

  Map<String, dynamic> toJson() => {
        "fecha": fecha,
        "Articulo": articulo.toJson(),
        "estado": estado,
        "idTraspaso": idTraspaso,
        "Usuario": usuario.toJson(),
        "SucursalEntrada": sucursalEntrada.toJson(),
        "SucursalSalida": sucursalSalida.toJson(),
      };
}
