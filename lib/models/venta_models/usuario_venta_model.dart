import 'dart:convert';

class UsuarioVentaModel {
  UsuarioVentaModel({
    required this.idUsuario,
    required this.nombre,
  });

  String idUsuario;
  String nombre;

  factory UsuarioVentaModel.fromRawJson(String str) =>
      UsuarioVentaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UsuarioVentaModel.fromJson(Map<String, dynamic> json) =>
      UsuarioVentaModel(
        idUsuario: json["idUsuario"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "nombre": nombre,
      };
}
