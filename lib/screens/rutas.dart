import 'package:flutter/cupertino.dart';
import 'package:puntos_ventas_tt/screens/acceso_screens/permisos_screen.dart';
import 'package:puntos_ventas_tt/screens/acceso_screens/sucursal_screen.dart';
import 'package:puntos_ventas_tt/screens/acceso_screens/usuarios_screen.dart';
import 'package:puntos_ventas_tt/screens/acerca_de_screen.dart';
import 'package:puntos_ventas_tt/screens/almacen_screens/almacen_screens.dart';
import 'package:puntos_ventas_tt/screens/ayuda_pventa_screen.dart';
import 'package:puntos_ventas_tt/screens/compras_screens/compras_screen.dart';
import 'package:puntos_ventas_tt/screens/consulta_compras_screen.dart';
import 'package:puntos_ventas_tt/screens/consulta_ventas_screen.dart';
import 'package:puntos_ventas_tt/screens/escritorio_screen.dart';
import 'package:puntos_ventas_tt/screens/tiendas_login_screen.dart';
import 'package:puntos_ventas_tt/screens/ventas_screens/clientes_screen.dart';
import 'package:puntos_ventas_tt/screens/ventas_screens/devoluciones_screen.dart';
import 'package:puntos_ventas_tt/screens/ventas_screens/venta_screen.dart';

class Rutas {
  static String imageRute = 'assets/';

  static Map<String, Widget Function(BuildContext)> get routes => {
        //background
        //BackgroundImg.routePage: (_) => BackgroundImg(),

        //login, selector de tiendas | sucursal
        TiendasLoginScreen.routePage: (_) => const TiendasLoginScreen(),

        //Opcion escritorio
        EscritorioScreen.routePage: (_) => const EscritorioScreen(),
        //Opciones Almacen
        ArticulosScreen.routePage: (_) => const ArticulosScreen(),
        CategoriasScreen.routePage: (_) => const CategoriasScreen(),
        AjustesScreen.routePage: (_) => const AjustesScreen(),
        TraspasosScreen.routePage: (_) => const TraspasosScreen(),

        //Opcion Compras
        IngresosScreen.routePage: (_) => const IngresosScreen(),
        ProveedoresScreen.routePage: (_) => const ProveedoresScreen(),

        //Opcion Ventas
        VentaScreen.routePage: (_) => const VentaScreen(),
        DevolucionesScreen.routePage: (_) => const DevolucionesScreen(),
        ClientesScreen.routePage: (_) => const ClientesScreen(),

        //Opcion Acceso
        UsuariosScreen.routePage: (_) => const UsuariosScreen(),
        PermisosScreen.routePage: (_) => const PermisosScreen(),
        SucursalScreen.routePage: (_) => const SucursalScreen(),

        ConsultaComprasScreen.routePage: (_) => const ConsultaComprasScreen(),
        ConsultaVentasScreen.routePage: (_) => const ConsultaVentasScreen(),

        //pantalla ayuda
        AyudaPventaScreen.routePage: (_) => const AyudaPventaScreen(),
        //Acerca de
        AcercaDeScreen.routePage: (_) => const AcercaDeScreen(),
      };
  static String get inicialPantalla => TiendasLoginScreen.routePage;
  //static String get inicialPantalla => HomeScreen.routePage;
}
//< alt 60 > alt 62 

