// To parse this JSON data, do
//
//     final personaModel = personaModelFromJson(jsonString);

import 'dart:convert';

class PersonaModel {
  PersonaModel({
    required this.direccion,
    required this.documento,
    required this.email,
    required this.id,
    required this.nombre,
    required this.numeroDocumento,
    required this.telefono,
  });

  String direccion;
  String documento;
  String email;
  String id;
  String nombre;
  String numeroDocumento;
  String telefono;

  factory PersonaModel.fromRawJson(String str) =>
      PersonaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonaModel.fromJson(Map<String, dynamic> json) => PersonaModel(
        direccion: json["direccion"],
        documento: json["documento"],
        email: json["email"],
        id: json["id"],
        nombre: json["nombre"],
        numeroDocumento: json["numeroDocumento"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "direccion": direccion,
        "documento": documento,
        "email": email,
        "id": id,
        "nombre": nombre,
        "numeroDocumento": numeroDocumento,
        "telefono": telefono,
      };
}
