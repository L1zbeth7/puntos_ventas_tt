import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/screens/rutas.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Punto Venta',
      initialRoute: Rutas.inicialPantalla,
      routes: Rutas.routes,
    );
  }
}
