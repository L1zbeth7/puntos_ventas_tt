// To parse this JSON data, do
//
//     final ventaModel = ventaModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puntos_ventas_tt/models/models.dart';

class VentaModelV {
  VentaModelV({
    required this.cliente,
    required this.fecha,
    required this.impuesto,
    required this.serieComprobante,
    required this.detalle,
    required this.totalVenta,
    required this.numeroComprobante,
    required this.tipoComprobante,
    required this.activo,
    required this.idVenta,
    required this.usuario,
    required this.sucursal,
  });

  ClienteVentaModel cliente;
  Timestamp fecha;
  double impuesto;
  String serieComprobante;
  List<ArticuloVentaModel> detalle;
  double totalVenta;
  String numeroComprobante;
  String tipoComprobante;
  bool activo;
  String idVenta;
  UsuarioVentaModel usuario;
  SucursalVentaModel sucursal;

  factory VentaModelV.fromRawJson(String str) =>
      VentaModelV.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VentaModelV.fromJson(Map<String, dynamic> json) => VentaModelV(
        cliente: json["cliente"],
        fecha: json["fecha"],
        impuesto: json["impuesto"],
        serieComprobante: json["serieComprobante"],
        detalle: json["detalle"],
        totalVenta: json["totalVenta"],
        numeroComprobante: json["numeroComprobante"],
        tipoComprobante: json["tipoComprobante"],
        activo: json["activo"],
        idVenta: json["idVenta"],
        usuario: json["usuario"],
        sucursal: json["sucursal"],
      );

  Map<String, dynamic> toJson() => {
        "cliente": cliente,
        "fecha": fecha,
        "impuesto": impuesto,
        "serieComprobante": serieComprobante,
        "detalle": detalle,
        "totalVenta": totalVenta,
        "numeroComprobante": numeroComprobante,
        "tipoComprobante": tipoComprobante,
        "activo": activo,
        "idVenta": idVenta,
        "usuario": usuario,
        "sucursal": sucursal,
      };
}
