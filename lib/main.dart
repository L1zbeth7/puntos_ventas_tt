import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/consulta_compras_controller.dart';
import 'package:puntos_ventas_tt/controllers/consulta_ventas_controller.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/controllers/escritorio_controller.dart';
import 'package:puntos_ventas_tt/screens/rutas.dart';

void main() => runApp(const _AppState());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Punto Venta',
      initialRoute: Rutas.inicialPantalla,
      routes: Rutas.routes,
      theme: ThemeData.light().copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _AppState extends StatelessWidget {
  const _AppState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => EscritorioController()),
      //Almacen Opcion
      ChangeNotifierProvider(create: (_) => ArticulosController()),
      ChangeNotifierProvider(create: (_) => CategoriasController()),
      ChangeNotifierProvider(create: (_) => AjusteController()),
      ChangeNotifierProvider(create: (_) => TraspasosController()),
      //Compras Opcion
      ChangeNotifierProvider(create: (_) => IngresosController()),
      ChangeNotifierProvider(create: (_) => ProveedoresController()),
      //Ventas Opcion
      ChangeNotifierProvider(create: (_) => VentaController()),
      ChangeNotifierProvider(create: (_) => DevolucionesController()),
      ChangeNotifierProvider(create: (_) => ClientesController()),
      //Acceso Opcion
      ChangeNotifierProvider(create: (_) => UsuariosController()),
      ChangeNotifierProvider(create: (_) => SucursalesController()),
      //Consultas
      ChangeNotifierProvider(create: (_) => ConsultaComprasController()),
      ChangeNotifierProvider(create: (_) => ConsultaVentasController()),
    ], child: const MyApp());
  }
}
