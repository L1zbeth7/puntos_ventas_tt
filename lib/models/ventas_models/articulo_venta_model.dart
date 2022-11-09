// To parse this JSON data, do
//
//     final proveedorModel = proveedorModelFromJson(jsonString);

import 'dart:convert';

List<ArticuloVentaModel> articuloVentaModelFromJson(String str) =>
    List<ArticuloVentaModel>.from(
        json.decode(str).map((x) => ArticuloVentaModel.fromJson(x)));

List<Map<String, dynamic>> articuloVentaModelToJson(
        List<ArticuloVentaModel> data) =>
    List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

class ArticuloVentaModel {
  ArticuloVentaModel({
    required this.idArticulo,
    required this.articulo,
    required this.codigo,
    required this.cantidad,
    required this.precioVenta,
    required this.descuento,
    required this.subtotal,
  });

  String idArticulo;
  String articulo;
  String codigo;
  double cantidad;
  double precioVenta;
  double descuento;
  double subtotal;

  factory ArticuloVentaModel.fromRawJson(String str) =>
      ArticuloVentaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArticuloVentaModel.fromJson(Map<String, dynamic> json) =>
      ArticuloVentaModel(
        idArticulo: json["idArticulo"],
        articulo: json["articulo"],
        codigo: json["codigo"],
        cantidad: json["cantidad"].toDouble(),
        precioVenta: json["precioVenta"].toDouble(),
        descuento: json["descuenta"].toDouble(),
        subtotal: json["subtotal"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "idArticulo": idArticulo,
        "articulo": articulo,
        "codigo": codigo,
        "cantidad": cantidad,
        "precioVenta": precioVenta,
        "descuenta": descuento,
        "subtotal": subtotal,
      };
}
