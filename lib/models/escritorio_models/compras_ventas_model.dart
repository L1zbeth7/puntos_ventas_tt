// To parse this JSON data, do
//
//     final comprasModel = comprasModelFromJson(jsonString);

import 'dart:convert';

List<ComprasVentasModel> comprasModelFromJson(String str) =>
    List<ComprasVentasModel>.from(
        json.decode(str).map((x) => ComprasVentasModel.fromJson(x)));

String comprasModelToJson(List<ComprasVentasModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComprasVentasModel {
  ComprasVentasModel({
    required this.fecha,
    required this.total,
  });

  String fecha;
  double total;

  factory ComprasVentasModel.fromJson(Map<String, dynamic> json) =>
      ComprasVentasModel(
        fecha: json["fecha"],
        total: double.parse(json["total"]),
      );

  Map<String, dynamic> toJson() => {
        "fecha": fecha,
        "total": total.toString(),
      };
}
