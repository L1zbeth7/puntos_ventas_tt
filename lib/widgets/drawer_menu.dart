import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/consulta_compras_controller.dart';
import 'package:puntos_ventas_tt/controllers/consulta_ventas_controller.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/screens/consulta_compras_screen.dart';
import 'package:puntos_ventas_tt/screens/consulta_ventas_screen.dart';
import 'package:puntos_ventas_tt/screens/screens.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key, required this.routeActual});

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _OpcionesMenu(routeActual: routeActual),
    );
  }
}

class _OpcionesMenu extends StatelessWidget {
  const _OpcionesMenu({
    Key? key,
    required this.routeActual,
  }) : super(key: key);

  final String routeActual;

  @override
  Widget build(BuildContext context) {
    UserPreferencesSecure userPreferences = UserPreferencesSecure();
    return Stack(children: [
      ListView(padding: EdgeInsets.zero, children: [
        _CustomHeader(),
        //Opcion 1, escritorio
        FutureBuilder(
            future: userPreferences.getPermiso('Escritorio'),
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
            future: userPreferences.getPermiso('Almacen'),
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
            future: userPreferences.getPermiso('Compras'),
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
            future: userPreferences.getPermiso('Ventas'),
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
            future: userPreferences.getPermiso('Acceso'),
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
            future: userPreferences.getPermiso('Consultas Compras'),
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
            future: userPreferences.getPermiso('Consulta Ventas'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data) {
                  return _ConsultaVentasOption(routeActual: routeActual);
                }
              }
              return Container();
            }),
        // _OptionEscritorio(routeActual: routeActual),
        // _AlmacenOption(routeActual: routeActual),
        // _ComprasOption(routeActual: routeActual),
        // _VentasOption(routeActual: routeActual),
        // _AccesoOption(routeActual: routeActual),

        // _ConsultaComprasOption(routeActual: routeActual),
        // _ConsultaVentasOption(routeActual: routeActual),

        _AyudaOption(routeActual: routeActual),
        _AcercadeOption(routeActual: routeActual),
        Container(height: 50),
        // const SizedBox(height: 20),
        // const _BotonCambiarTienda(),
      ]),
      const SizedBox(height: 25),
      const Align(
        alignment: Alignment.bottomCenter,
        child: _BotonCambiarTienda(),
      )
    ]);
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
              ? Colors.black12
              : null),
      child: ListTile(
        title: const Text(
          'Escritorio',
          style: TextStyle(fontSize: 17),
        ),
        trailing: Icon(Icons.bar_chart, color: Colors.blue[900]),
        onTap: () {
          Navigator.pushReplacementNamed(context, EscritorioScreen.routePage);
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
                routeActual == CategoriasScreen.routePage ||
                routeActual == AjustesScreen.routePage ||
                routeActual == TraspasosScreen.routePage
            ? Colors.black12
            : null),
      ),
      child: ExpansionTile(
        title: const Text('Almacen', style: TextStyle(fontSize: 17)),
        children: [
          ListTile(
            title: const Text('Articulos'),
            trailing: Icon(Icons.add_shopping_cart, color: Colors.blue[900]),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ArticulosScreen.routePage);
            },
          ),
          ListTile(
            title: const Text('Categorias'),
            trailing: Icon(Icons.topic_outlined, color: Colors.blue[900]),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, CategoriasScreen.routePage);

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
              Navigator.pushReplacementNamed(context, AjustesScreen.routePage);
            },
          ),
          ListTile(
            title: const Text('Traspasos'),
            trailing: Icon(Icons.add_to_home_screen, color: Colors.blue[900]),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, TraspasosScreen.routePage);
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
      decoration: BoxDecoration(
          color: routeActual == IngresosScreen.routePage ||
                  routeActual == ProveedoresScreen.routePage
              ? Colors.black12
              : null),
      child: ExpansionTile(
        title: const Text('Compras', style: TextStyle(fontSize: 17)),
        children: [
          ListTile(
            title: const Text('Ingresos'),
            trailing:
                Icon(Icons.monetization_on_outlined, color: Colors.blue[900]),
            onTap: () {
              final ingresoController =
                  Provider.of<IngresosController>(context, listen: false);
              ingresoController.limpiarFormulario();
              ingresoController.getIngresos();
              Navigator.pushReplacementNamed(context, IngresosScreen.routePage);
            },
          ),
          ListTile(
            title: const Text('Proveedores'),
            trailing:
                Icon(Icons.local_shipping_outlined, color: Colors.blue[900]),
            onTap: () {
              final proveedoresController =
                  Provider.of<ProveedoresController>(context, listen: false);
              proveedoresController.getProveedores();

              Navigator.pushReplacementNamed(
                  context, ProveedoresScreen.routePage);
              //print('boton proveedores');
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
      decoration: BoxDecoration(
          color: routeActual == VentaScreen.routePage ||
                  routeActual == DevolucionesScreen.routePage ||
                  routeActual == ClientesScreen.routePage
              ? Colors.black12
              : null),
      child: ExpansionTile(
        title: const Text('Ventas', style: TextStyle(fontSize: 17)),
        children: [
          ListTile(
            title: const Text('Ventas'),
            trailing: Icon(Icons.local_mall_outlined, color: Colors.blue[900]),
            onTap: () {
              final ventasController =
                  Provider.of<VentaController>(context, listen: false);
              ventasController.getVentas();
              Navigator.pushReplacementNamed(context, VentaScreen.routePage);
            },
          ),
          ListTile(
            title: const Text('Devoluciones'),
            trailing: Icon(Icons.rotate_left, color: Colors.blue[900]),
            onTap: () {
              final devolucionController =
                  Provider.of<DevolucionesController>(context, listen: false);
              devolucionController.getArticulosActivos();
              devolucionController.getClientesActivos();
              devolucionController.limpiarFormulario();
              Navigator.pushReplacementNamed(
                  context, DevolucionesScreen.routePage);
            },
          ),
          ListTile(
            title: const Text('Clientes'),
            trailing: Icon(Icons.groups_outlined, color: Colors.blue[900]),
            onTap: () {
              final clienteController =
                  Provider.of<ClientesController>(context, listen: false);
              clienteController.getClientes();

              Navigator.pushReplacementNamed(context, ClientesScreen.routePage);
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
      decoration: BoxDecoration(
        color: routeActual == UsuariosScreen.routePage ||
                routeActual == PermisosScreen.routePage ||
                routeActual == SucursalScreen.routePage
            ? Colors.black12
            : null,
      ),
      child: ExpansionTile(
        title: const Text('Acceso', style: TextStyle(fontSize: 17)),
        children: [
          ListTile(
            title: const Text('Usuarios'),
            trailing: Icon(Icons.group_outlined, color: Colors.blue[900]),
            onTap: () {
              final usuariosController =
                  Provider.of<UsuariosController>(context, listen: false);
              usuariosController.getUsuarios();
              usuariosController.getSucursales();

              Navigator.pushReplacementNamed(context, UsuariosScreen.routePage);
            },
          ),
          ListTile(
            title: const Text('Permisos'),
            trailing: Icon(Icons.key, color: Colors.blue[900]),
            onTap: () => Navigator.pushReplacementNamed(
                context, PermisosScreen.routePage),
          ),
          ListTile(
            title: const Text('Sucursales'),
            trailing: Icon(Icons.storefront, color: Colors.blue[900]),
            onTap: () {
              final sucursalesControlle =
                  Provider.of<SucursalesController>(context, listen: false);
              sucursalesControlle.getSucursales();

              Navigator.pushReplacementNamed(context, SucursalScreen.routePage);
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
      decoration: BoxDecoration(
          color: routeActual == ConsultaComprasScreen.routePage
              ? Colors.black12
              : null),
      child: ListTile(
        title: const Text('Consulta Compras', style: TextStyle(fontSize: 17)),
        trailing: Icon(Icons.feed_outlined, color: Colors.blue[900]),
        onTap: () {
          final consultaCController =
              Provider.of<ConsultaComprasController>(context, listen: false);
          consultaCController.reiniciarFechas();
          consultaCController.getCompras();

          Navigator.pushReplacementNamed(
              context, ConsultaComprasScreen.routePage);
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
      decoration: BoxDecoration(
          color: routeActual == ConsultaVentasScreen.routePage
              ? Colors.black12
              : null),
      child: ListTile(
        title: const Text('Consulta Ventas', style: TextStyle(fontSize: 17)),
        trailing: Icon(Icons.request_page_outlined, color: Colors.blue[900]),
        onTap: () {
          final consultaVController =
              Provider.of<ConsultaVentasController>(context, listen: false);
          consultaVController.reiniciarFechas();
          consultaVController.getCompras();

          Navigator.pushReplacementNamed(
              context, ConsultaVentasScreen.routePage);
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
              ? Colors.black12
              : null),
      child: ListTile(
        title: const Text(
          'Ayuda',
          style: TextStyle(fontSize: 17),
        ),
        trailing: Icon(Icons.help_outline, color: Colors.blue[900]),
        onTap: () {
          Navigator.pushReplacementNamed(context, AyudaPventaScreen.routePage);
        },
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
          color:
              routeActual == AcercaDeScreen.routePage ? Colors.black12 : null),
      child: ListTile(
        title: const Text(
          'Acerca de',
          style: TextStyle(fontSize: 17),
        ),
        trailing: Icon(Icons.info_outline, color: Colors.blue[900]),
        onTap: () {
          Navigator.pushReplacementNamed(context, AcercaDeScreen.routePage);
        },
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
              Navigator.pushReplacementNamed(
                  context, TiendasLoginScreen.routePage);
            },
            child: const Text('Cambiar Tienda',
                style: TextStyle(color: Colors.white)),
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
