import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/almacenMenu/categorias_controller.dart';
import 'package:puntos_ventas_tt/screens/screens.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
//import 'package:puntos_ventas_tt/utils/user_preferences.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key, required this.routeActual});

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    //UserPreferences userPreferences = UserPreferences();
    return Drawer(
      child: Stack(children: [
        ListView(padding: EdgeInsets.zero, children: [
          _CustomHeader(),

          //prueba
          // ListTile(
          //   title: const Text('Escritorio'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const EscritorioScreen()),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: const Text('Almacen'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const CategoriasScreen()),
          //     );
          //   },
          // ),

          //fin prueba

          //Opcion 1, escritorio
          FutureBuilder(
              //future: userPreferences.getPermiso('Escritorio'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return _OptionEscritorio(routeActual: routeActual);
              }
            }
            return Container();
          }),
          //Opcion 2, almacen
          FutureBuilder(
              //future: userPreferences.getPermiso('Almacen'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return _AlmacenOption(routeActual: routeActual);
              }
            }
            return Container();
          }),
          //Opcion 3, compras
          FutureBuilder(
              //future: userPreferences.getPermiso('Compras'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return _ComprasOption(routeActual: routeActual);
              }
            }
            return Container();
          }),
          //Opcion 4, ventas
          FutureBuilder(
              //future: userPreferences.getPermiso('Ventas'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return _VentasOption(routeActual: routeActual);
              }
            }
            return Container();
          }),
          //opcion 5, acceso
          FutureBuilder(
              //future: userPreferences.getPermiso('Acceso'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return _AccesoOption(routeActual: routeActual);
              }
            }
            return Container();
          }),
          //opcion 6, consulta compras
          FutureBuilder(
              //future: userPreferences.getPermiso('Consultas Compras'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return _ConsultaComprasOption(routeActual: routeActual);
              }
            }
            return Container();
          }),
          //opcion 7, consulta ventas
          FutureBuilder(
              //future: userPreferences.getPermiso('Consulta Ventas'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return _ConsultaVentasOption(routeActual: routeActual);
              }
            }
            return Container();
          }),
          _OptionEscritorio(routeActual: routeActual),
          _AlmacenOption(routeActual: routeActual),

          _AyudaOption(routeActual: routeActual),
          _AcercadeOption(routeActual: routeActual),
          //Container(height: 50),
        ]),
        const Align(
          alignment: Alignment.bottomCenter,
          child: _BotonCambiarTienda(),
        )
      ]),
    );
  }
}

//opcion 1
class _OptionEscritorio extends StatelessWidget {
  const _OptionEscritorio({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: routeActual == EscritorioScreen.routePage
              ? Colors.blue[100]
              : null),
      child: ListTile(
        title: const Text(
          'Escritorio',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        trailing: Icon(Icons.bar_chart, color: Colors.blue[900]),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EscritorioScreen()));

          // Navigator.pushReplacementNamed(context, EscritorioScreen.routePage);
        },
      ),
    );
  }
}

//opcion 2
class _AlmacenOption extends StatelessWidget {
  const _AlmacenOption({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (routeActual == ArticulosScreen.routePage ||
                routeActual == CategoriasScreen.routePage
            ? Colors.blue[100]
            : null),
      ),
      child: ExpansionTile(
        title: const Text('Almacen',
            style: TextStyle(fontSize: 18, color: Colors.black)),
        children: [
          ListTile(
            title: const Text('Articulos'),
            trailing: Icon(Icons.add_shopping_cart, color: Colors.blue[900]),
            onTap: () {
              print('boton articulos');
            },
          ),
          ListTile(
            title: const Text('Categorias'),
            trailing: Icon(Icons.schema, color: Colors.blue[900]),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriasScreen()));

              // final categoriaController =
              //     Provider.of<CategoriasController>(context, listen: false);
              // categoriaController.pantallaActiva = 0;
              // categoriaController.getcategorias();
              // Navigator.pushReplacementNamed(
              //     context, CategoriasScreen.routePage);
            },
          ),
          ListTile(
            title: const Text('Ajustes'),
            trailing: Icon(Icons.settings, color: Colors.blue[900]),
            onTap: () {
              print('boton ajustes');
            },
          ),
          ListTile(
            title: const Text('Traspasos'),
            trailing: Icon(Icons.add_to_home_screen, color: Colors.blue[900]),
            onTap: () {
              print('boton traspasos');
            },
          ),
        ],
      ),
    );
  }
}

//opcion 3
class _ComprasOption extends StatelessWidget {
  const _ComprasOption({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: ExpansionTile(
        title: const Text('Compras'),
        children: [
          ListTile(
            title: const Text('Ingresos'),
            trailing:
                Icon(Icons.monetization_on_outlined, color: Colors.blue[900]),
            onTap: () {
              print('boton ingresos');
            },
          ),
          ListTile(
            title: const Text('Proveedores'),
            trailing:
                Icon(Icons.local_shipping_outlined, color: Colors.blue[900]),
            onTap: () {
              print('boton proveedores');
            },
          )
        ],
      ),
    );
  }
}

//opcion 4
class _VentasOption extends StatelessWidget {
  const _VentasOption({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: ExpansionTile(
        title: const Text('Ventas'),
        children: [
          ListTile(
            title: const Text('Ventas'),
            trailing: Icon(Icons.local_mall_outlined, color: Colors.blue[900]),
            onTap: () {
              print('boton ventas');
            },
          ),
          ListTile(
            title: const Text('Devoluciones'),
            trailing: Icon(Icons.rotate_left, color: Colors.blue[900]),
            onTap: () {
              print('boton devoluciones');
            },
          ),
          ListTile(
            title: const Text('Clientes'),
            trailing: Icon(Icons.groups_outlined, color: Colors.blue[900]),
            onTap: () {
              print('boton clientes');
            },
          )
        ],
      ),
    );
  }
}

//opcion 5
class _AccesoOption extends StatelessWidget {
  const _AccesoOption({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: ExpansionTile(
        title: const Text('Acceso'),
        children: [
          ListTile(
            title: const Text('Usuarios'),
            trailing: Icon(Icons.group_outlined, color: Colors.blue[900]),
            onTap: () {
              print('boton usuarios');
            },
          ),
          ListTile(
            title: const Text('Permisos'),
            trailing: Icon(Icons.key, color: Colors.blue[900]),
            onTap: () {
              print('boton permisos');
            },
          ),
          ListTile(
            title: const Text('Sucursales'),
            trailing: Icon(Icons.storefront, color: Colors.blue[900]),
            onTap: () {
              print('boton sucursales');
            },
          ),
        ],
      ),
    );
  }
}

//opcion 6
class _ConsultaComprasOption extends StatelessWidget {
  const _ConsultaComprasOption({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: ListTile(
        title: const Text('Consulta Compras'),
        trailing: Icon(Icons.receipt_long_outlined, color: Colors.blue[900]),
        onTap: () {
          print('boton consulta compras');
        },
      ),
    );
  }
}

//opcion 7
class _ConsultaVentasOption extends StatelessWidget {
  const _ConsultaVentasOption({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: ListTile(
        title: const Text('Consulta Ventas'),
        trailing: Icon(Icons.trending_up, color: Colors.blue[900]),
        onTap: () {
          print('boton consulta ventas');
        },
      ),
    );
  }
}

//opcion 8
class _AyudaOption extends StatelessWidget {
  const _AyudaOption({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: routeActual == AyudaPventaScreen.routePage
              ? Colors.blue[100]
              : null),
      child: ListTile(
        title: const Text(
          'Ayuda',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        trailing: Icon(Icons.help_outline, color: Colors.blue[900]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AyudaPventaScreen()),
          );
        },
        // routeActual == AyudaPventaScreen.routePage
        //     ? null
        //     : () => Navigator.pushReplacementNamed(
        //         context, AyudaPventaScreen.routePage),
      ),
    );
  }
}

//opcion 9
class _AcercadeOption extends StatelessWidget {
  const _AcercadeOption({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: routeActual == AcercaDeScreen.routePage
              ? Colors.blue[100]
              : null),
      child: ListTile(
        title: const Text(
          'Acerca de',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        trailing: Icon(Icons.info_outline, color: Colors.blue[900]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AcercaDeScreen()),
          );
        },
        // routeActual == AcercaDeScreen.routePage
        //     ? null
        //     : () => Navigator.pushReplacementNamed(
        //         context, AcercaDeScreen.routePage),
      ),
    );
  }
}

class _BotonCambiarTienda extends StatelessWidget {
  const _BotonCambiarTienda({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Column(
        children: [
          TextButton(
            style: StyleTexto.getButtonStyle(Colors.redAccent),
            onPressed: () {
              print('boton cambiar tienda');
            },
            child: Text('Cambiar Tienda', style: StyleTexto.styleTextbutton),
          )
        ],
      ),
    );
  }
}

//contiene la imagen que se muestra al inicio de drawer
class _CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/user.png'),
            fit: BoxFit.cover //amdapta la imagen
            ),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.end, //posiciona al final de la columna
        children: const [
          //envuelve el texto en un tipo letrero
          TagContainer(text: 'Usuario'),
        ],
      ),
    );
  }
}

//propiedades de la foto perfin
//se visualiza como un boton (letrero) con el nombre del usuario o cargo
class TagContainer extends StatelessWidget {
  const TagContainer({super.key, required this.text});

  final String text; //crea este campo y lo pide al usar la clase

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(25)), //tamaño del containe
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
