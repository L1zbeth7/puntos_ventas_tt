// To parse this JSON data, do
//
//     final ingresoModel = ingresoModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puntos_ventas_tt/models/models.dart';

class IngresoModel {
  IngresoModel({
    required this.proveedor,
    required this.fecha,
    required this.impuesto,
    required this.serieComprobante,
    required this.detalle,
    required this.totalIngreso,
    required this.numeroComprobante,
    required this.tipoComprobante,
    required this.activo,
    required this.idVenta,
    required this.usuario,
    required this.sucursal,
  });

  ProveedorModel proveedor;
  Timestamp fecha;
  double impuesto;
  String serieComprobante;
  List<ArticuloVentaModel> detalle;
  double totalIngreso;
  String numeroComprobante;
  String tipoComprobante;
  bool activo;
  String idVenta;
  UsuarioVentaModel usuario;
  SucursalVentaModel sucursal;

  factory IngresoModel.fromRawJson(String str) =>
      IngresoModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IngresoModel.fromJson(Map<String, dynamic> json) => IngresoModel(
        proveedor: json["Proveedor"],
        fecha: json["fecha"],
        impuesto: json["impuesto"],
        serieComprobante: json["serieComprobante"],
        detalle: json["detalle"],
        totalIngreso: json["totalIngreso"],
        numeroComprobante: json["numeroComprobante"],
        tipoComprobante: json["tipoComprobante"],
        activo: json["activo"],
        idVenta: json["idVenta"],
        usuario: json["Usuario"],
        sucursal: json["sucursal"],
      );

  Map<String, dynamic> toJson() => {
        "Proveedor": proveedor,
        "fecha": fecha,
        "impuesto": impuesto,
        "serieComprobante": serieComprobante,
        "detalle": detalle,
        "totalIngreso": totalIngreso,
        "numeroComprobante": numeroComprobante,
        "tipoComprobante": tipoComprobante,
        "activo": activo,
        "idVenta": idVenta,
        "Usuario": usuario,
        "sucursal": sucursal,
      };
}
