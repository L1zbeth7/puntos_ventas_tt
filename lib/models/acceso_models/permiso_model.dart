import 'dart:convert';

PermisoModelA permisosModelFromJson(String str) =>
    PermisoModelA.fromJson(json.decode(str));

String permisosModelToJson(PermisoModelA data) => json.encode(data.toJson());

class PermisoModelA {
  PermisoModelA({
    required this.escritorio,
    required this.almacen,
    required this.compras,
    required this.ventas,
    required this.acceso,
    required this.consultaCompras,
    required this.consultaVentas,
  });

  bool escritorio;
  bool almacen;
  bool compras;
  bool ventas;
  bool acceso;
  bool consultaVentas;
  bool consultaCompras;

  factory PermisoModelA.fromJson(Map<String, dynamic> json) => PermisoModelA(
        escritorio: json["Escritorio"],
        almacen: json["Almacen"],
        compras: json["Compras"],
        ventas: json["Ventas"],
        acceso: json["Acceso"],
        consultaVentas: json["Consulta Ventas"],
        consultaCompras: json["Consulta Compras"],
      );

  Map<String, dynamic> toJson() => {
        "Escritorio": escritorio,
        "Almacen": almacen,
        "Compras": compras,
        "Ventas": ventas,
        "Acceso": acceso,
        "Consulta Ventas": consultaVentas,
        "Consulta Compras": consultaCompras,
      };
}
