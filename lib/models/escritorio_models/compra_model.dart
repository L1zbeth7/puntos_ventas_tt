// To parse this JSON data, do
//
//     final compraModel = compraModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CompraModel compraModelFromJson(String str) =>
    CompraModel.fromJson(json.decode(str));

String compraModelToJson(CompraModel data) => json.encode(data.toJson());

class CompraModel {
  CompraModel({
    required this.usuario,
    required this.fecha,
    required this.impuesto,
    required this.serieComprobante,
    required this.totalcompra,
    required this.numeroComprobante,
    required this.tipoComprobante,
    required this.subTotal,
    required this.idIngreso,
    required this.activo,
  });

  factory CompraModel.fromRawJson(String str) =>
      CompraModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  final String usuario;
  final Timestamp fecha;
  final int impuesto;
  final String serieComprobante;
  final double totalcompra;
  final String numeroComprobante;
  final String tipoComprobante;
  final double subTotal;
  final String idIngreso;
  final bool activo;

  factory CompraModel.fromJson(Map<String, dynamic> json) {
    //var number = StringToTime.getNumbers(json["fecha"]);

    return CompraModel(
      usuario: json["usuario"],
      fecha: json["fecha"],
      impuesto: json["impuesto"],
      serieComprobante: json["serieComprobante"],
      totalcompra: json["totalCompra"].toDouble(),
      numeroComprobante: json["numeroComprobante"],
      tipoComprobante: json["tipoComprobante"],
      subTotal: json["subTotal"].toDouble(),
      idIngreso: json["idIngreso"],
      activo: json["activo"],
    );
  }

  Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "fecha": fecha,
        "impuesto": impuesto,
        "serieComprobante": serieComprobante,
        "totalCompra": totalcompra,
        "numeroComprobante": numeroComprobante,
        "tipoComprobante": tipoComprobante,
        "subTotal": subTotal,
        "idIngreso": idIngreso,
        "activo": activo,
      };
}
