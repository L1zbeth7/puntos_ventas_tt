import 'package:flutter/cupertino.dart';
import 'package:puntos_ventas_tt/screens/acerca_de_screen.dart';
import 'package:puntos_ventas_tt/screens/almacenMenu/articulos_screen.dart';
import 'package:puntos_ventas_tt/screens/almacenMenu/categorias_screen.dart';
import 'package:puntos_ventas_tt/screens/almacenMenu/traspasos_screen.dart';
import 'package:puntos_ventas_tt/screens/ayuda_pventa_screen.dart';
import 'package:puntos_ventas_tt/screens/home_screen.dart';
import 'package:puntos_ventas_tt/screens/menuDrawer/escritorio_screen.dart';
import 'package:puntos_ventas_tt/screens/tiendas_login_screen.dart';
import 'package:puntos_ventas_tt/widgets/background_img.dart';

class Rutas {
  static String imageRute = 'assets/images';

  static Map<String, Widget Function(BuildContext)> get routes => {
        //background
        BackgroundImg.routePage: (_) => BackgroundImg(),
        HomeScreen.routePage: (_) => const HomeScreen(),

        //login, selector de tiendas | sucursal
        TiendasLoginScreen.routePage: (_) => const TiendasLoginScreen(),

        //Opcion escritorio
        EscritorioScreen.routePage: (_) => const EscritorioScreen(),
        //Opciones Almacen
        CategoriasScreen.routePage: (_) => const CategoriasScreen(),
        ArticulosScreen.routePage: (_) => const ArticulosScreen(),
        TraspasosScreen.routePage: (_) => const TraspasosScreen(),

        //pantalla ayuda
        AyudaPventaScreen.routePage: (_) => const AyudaPventaScreen(),
        //Acerca de
        AcercaDeScreen.routePage: (_) => const AcercaDeScreen(),
      };
  static String get inicialPantalla => TiendasLoginScreen.routePage;
  //static String get inicialPantalla => HomeScreen.routePage;
}
//< alt 60 > alt 62 

