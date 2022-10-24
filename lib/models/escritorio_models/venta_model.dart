// To parse this JSON data, do
//
//     final ventaModel = ventaModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puntos_ventas_tt/models/models.dart';

VentaModel ventaModelFromJson(String str) =>
    VentaModel.fromJson(json.decode(str));

String ventaModelToJson(VentaModel data) => json.encode(data.toJson());

class VentaModel {
  VentaModel({
    required this.cliente,
    required this.fecha,
    required this.impuesto,
    required this.serieComprobante,
    required this.totalVenta,
    required this.numeroComprobante,
    required this.tipoComprobante,
    required this.idVenta,
    required this.activo,
  });

  factory VentaModel.fromRawJson(String str) =>
      VentaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  final ClienteVentaModel cliente;
  final Timestamp fecha;
  final double impuesto;
  final String serieComprobante;
  final double totalVenta;
  final String numeroComprobante;
  final String tipoComprobante;
  final String idVenta;
  final bool activo;

  factory VentaModel.fromJson(Map<String, dynamic> json) {
    //var number = StringToTime.getNumbers(json["fecha"]);

    return VentaModel(
      cliente: ClienteVentaModel.fromJson(json["Cliente"]),
      fecha: json["fecha"],
      impuesto: json["impuesto"],
      serieComprobante: json["serieComprobante"],
      totalVenta: json["totalVenta"].toDouble(),
      numeroComprobante: json["numeroComprobante"],
      tipoComprobante: json["tipoComprobante"],
      idVenta: json["idVenta"],
      activo: json["activo"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Cliente": cliente.toJson(),
        "fecha": fecha,
        "impuesto": impuesto,
        "serieComprobante": serieComprobante,
        "totalVenta": totalVenta,
        "numeroComprobante": numeroComprobante,
        "tipoComprobante": tipoComprobante,
        "idVenta": idVenta,
        "activo": activo,
      };
}
