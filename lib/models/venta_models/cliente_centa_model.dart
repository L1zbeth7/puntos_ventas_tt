import 'dart:convert';

class ClienteVentaModel {
  ClienteVentaModel({
    required this.idCliente,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.email,
  });

  String idCliente;
  String nombre;
  String direccion;
  String telefono;
  String email;

  factory ClienteVentaModel.fromRawJson(String str) =>
      ClienteVentaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClienteVentaModel.fromJson(Map<String, dynamic> json) =>
      ClienteVentaModel(
        idCliente: json["idCliente"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        email: json["email"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "nombre": nombre,
        "direccion": direccion,
        "email": email,
        "telefono": telefono,
      };
}
