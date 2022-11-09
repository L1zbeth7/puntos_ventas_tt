import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/screens/rutas.dart';
import 'package:puntos_ventas_tt/utils/colores.dart';
import 'package:puntos_ventas_tt/utils/custom_launch.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class UsuariosScreen extends StatelessWidget {
  static String routePage = 'UsuariosScreen';
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuariosController>(context);

    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: Appbar.AppbarStyle(title: 'Usuarios'),
        drawer: DrawerMenu(routeActual: routePage),
        body: Stack(children: [
          BackgroundImg(),
          Padding(
            padding: const EdgeInsets.all(25),
            child: usuarioController.pantallaActiva == 0
                ? _PantallaPrincipal()
                : _PantallaFormulario(),
          ),
        ]),
      ),
    );
  }
}

class _PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _BotonespPrincipal(),
          const SizedBox(height: 15),
          _PantallaTabla(),
        ],
      ),
    );
  }
}

class _BotonespPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuariosController>(context);
    UsuarioFormController formController = UsuarioFormController();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.add, color: Colores.textColorButton),
                label: Text('Agregar', style: StyleTexto.styleTextbutton),
                style: StyleTexto.getButtonStyle(Colores.successColor),
                onPressed: () {
                  usuarioController.pantallaActiva = 1;
                  usuarioController.valorSwitch = true;
                  usuarioController.limpiarFormularioCompelto();
                  usuarioController.getSucursales();
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.description_outlined,
                    color: Colores.textColorButton),
                label: Text('Reporte', style: StyleTexto.styleTextbutton),
                style: StyleTexto.getButtonStyle(Colors.blue.shade600),
                onPressed: () {
                  usuarioController.getReporte();
                },
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.picture_as_pdf_outlined,
                    color: Colores.textColorButton),
                label: Text('PDF', style: StyleTexto.styleTextbutton),
                style: StyleTexto.getButtonStyle(Colores.dangerColor),
                onPressed: () {
                  usuarioController.getReporte(buscar: true);
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: TextField(
                controller: formController.buscar,
                decoration: InputDecoration(
                    suffixIcon: usuarioController.buscarVacio
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () {
                              usuarioController.buscarVacio = true;
                              FocusScope.of(context).unfocus();
                            },
                          ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Buscar',
                    labelText: 'Buscar'),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    usuarioController.buscarVacio = true;
                  } else {
                    usuarioController.buscarVacio = false;
                    usuarioController.buscarUsuarios();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PantallaTabla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuariosController>(context);

    return Container(
      decoration: StyleTexto.boxDecorationCard,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: _crearTabla(
                  context,
                  usuarioController.buscarVacio == true
                      ? usuarioController.usuarios
                      : usuarioController.usuariosBuscar),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<UsuarioModel> usuarios) {
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    List<UsuarioModel> usuarios = List.generate(
      2,
      (index) => UsuarioModel(
          idUsuario: 'idUsuario',
          idTlati: '123456',
          cargo: 'cargo',
          nombre: 'nombre'),
    );

    final boxDecoration = BoxDecoration(
      color: Colores.secondaryColor,
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(15),
    );

    const boxDecorationCell = BoxDecoration(
      border: Border(
          left: BorderSide(color: Colors.black54),
          right: BorderSide(color: Colors.black54)),
    );

    const boxConstraints = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(decoration: boxDecoration, children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(child: Text('Opciones', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            constraints: boxConstraints,
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(child: Text('Nombre', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(child: Text('Cargo', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(child: Text('Contacto 1', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(child: Text('Contacto 2', style: textColumStyle)),
          ),
        ),
      ]),
    );

    for (int i = 0; i < usuarios.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 2 != 0 ? Colors.white10 : Colors.white10,
        borderRadius: i % 1 != 0 ? BorderRadius.circular(25) : null,
      );

      celdas.add(
        TableRow(decoration: boxDecorationCellConten, children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Row(
                  children: [
                    _botonEditar(context, usuarios[i]),
                    const SizedBox(width: 15),
                    _botonEliminar(context, usuarios[i].idUsuario),
                  ],
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(child: Text(usuarios[i].nombre)),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(child: Text(usuarios[i].cargo)),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: TextButton(
                onPressed: usuarios[i].contacto1 != ''
                    ? () {
                        CustomLaunch.launchLlamada(usuarios[i].contacto1!);
                      }
                    : null,
                child: Text('${usuarios[i].contacto1}'),
              )),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: TextButton(
                onPressed: usuarios[i].contacto2 != ''
                    ? () {
                        CustomLaunch.launchLlamada(usuarios[i].contacto2!);
                      }
                    : null,
                child: Text('${usuarios[i].contacto2}'),
              )),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }

  _botonEditar(BuildContext context, UsuarioModel usuario) {
    final usuarioController =
        Provider.of<UsuariosController>(context, listen: false);
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colores.warningColor)),
      onPressed: () {
        usuarioController.pantallaActiva = 1;
        usuarioController.getUsuarioById(usuario.idUsuario);
      },
      child: Icon(Icons.edit, color: Colores.textColorButton),
    );
  }

  _botonEliminar(BuildContext context, String idUsuario) {
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colors.red)),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: roundedRectangleBorder,
              title: const Text('Alerta'),
              content: const Text('Seguro que quiere eliminar?'),
              actions: [_cancelButton(context), _okButton(context, idUsuario)],
            );
          },
        );
      },
      child: Icon(Icons.delete, color: Colores.textColorButton),
    );
  }

  _cancelButton(BuildContext context) => TextButton(
      onPressed: () => Navigator.pop(context), child: const Text('Cancelar'));

  _okButton(BuildContext context, String id) {
    final usuarioController =
        Provider.of<UsuariosController>(context, listen: false);

    return TextButton(
      onPressed: () {
        usuarioController.eliminarUsuario(id);
        Navigator.pop(context);
      },
      child: const Text('Ok'),
    );
  }
}

class _PantallaFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: StyleTexto.boxDecorationCard,
          margin: const EdgeInsets.only(bottom: 60),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _Formulario(),
          ),
        ),
        _BotonesFormulario(),
      ],
    );
  }
}

class _BotonesFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuariosController>(context);
    UsuarioFormController formController = UsuarioFormController();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.chevron_left, color: Colores.textColorButton),
              label: Text('Regresar', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(Colores.dangerColor),
              onPressed: () {
                usuarioController.pantallaActiva = 0;
                usuarioController.getUsuarios();
              },
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.save_outlined, color: Colores.textColorButton),
              label: Text('Guardar', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(Colores.secondaryColor),
              onPressed: () {
                if (formController.isValidForm) {
                  usuarioController.registrarUsuario();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Formulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuariosController>(context);
    UsuarioFormController formController = UsuarioFormController();

    return Form(
      key: formController.formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Usuario', style: StyleTexto.styleTextSubtitle),
            const SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: formController.idTlati,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      hintText: 'ID usuario',
                      labelText: 'ID usuario',
                      prefixIcon: Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        width: 15,
                        child: const Center(
                          child: Text(
                            'T-',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (usuarioController.usuario) {
                        return 'No se encontro usuario. Intente nuevamente';
                      }
                      if (value == null) {
                      } else {
                        if (value.isEmpty) {
                          return 'Ingresa un ID de usuario';
                        } else if (value.length != 5) {
                          return 'Ingresa un ID valido';
                        }
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.length == 5) {
                        usuarioController.getUsuario(value);
                        FocusManager.instance.primaryFocus!.unfocus();
                      } else {
                        usuarioController.limpiarFormulario();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colores.backgroundCardColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.qr_code_scanner,
                        color: Colores.textColorButton),
                    onPressed: () {
                      _escanerCamara(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.nombre,
              decoration: StyleTexto.getInputStyle('Nombre de Usuario'),
              enabled: false,
            ),
            if (usuarioController.imagen.isNotEmpty) const SizedBox(height: 15),
            if (usuarioController.imagen.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 75),
                child: FadeInImage(
                  placeholder:
                      AssetImage('${Rutas.imageRute}/image-loading.gif'),
                  image: CachedNetworkImageProvider(usuarioController.imagen),
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 15),
            Row(
              children: [
                if (formController.contacto1.text.isNotEmpty)
                  Flexible(
                    child: TextFormField(
                      controller: formController.contacto1,
                      decoration: StyleTexto.getInputStyle('Contacto 1'),
                      enabled: false,
                    ),
                  ),
                if (formController.contacto2.text.isNotEmpty &&
                    formController.contacto1.text.isNotEmpty)
                  const SizedBox(width: 15),
                if (formController.contacto2.text.isNotEmpty)
                  Flexible(
                    child: TextFormField(
                      controller: formController.contacto2,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: StyleTexto.getInputStyle('Contacto 2'),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.cargo,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              decoration: StyleTexto.getInputStyle('Cargo'),
              validator: (value) {
                return value == null
                    ? 'Ingresa un cargo'
                    : value.isEmpty
                        ? 'Ingresa un cargo'
                        : null;
              },
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Permisos(),
                SizedBox(width: 15),
                SucursalesFormWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _escanerCamara(BuildContext context) async {
    FocusManager.instance.primaryFocus!.unfocus();
    UsuarioFormController formController = UsuarioFormController();
    final usuarioController =
        Provider.of<UsuariosController>(context, listen: false);
    String barcodeScanres = await FlutterBarcodeScanner.scanBarcode(
        '#3d8BEF', 'Cancelar', false, ScanMode.BARCODE);

    if (barcodeScanres != '-1') {
      if (barcodeScanres.contains('T-')) {
        formController.idTlati.text = barcodeScanres.substring(2);
      } else {
        formController.idTlati.text = barcodeScanres;
      }
      await usuarioController.getUsuario(barcodeScanres);
    } else {
      formController.idTlati.text = '';
      const CustomToast(mensaje: 'No se escaneo el QR correctament')
          .showToast(context);
    }
  }
}

class Permisos extends StatelessWidget {
  const Permisos({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: permisosBuilder(),
          ),
        ),
      ),
    );
  }

  List<Widget> permisosBuilder() {
    UsuarioFormController formController = UsuarioFormController();
    List<Widget> checks = [];

    formController.permisosController.forEach((key, permiso) {
      checks.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(key)),
            CheckBoxPermiso(formController: formController, nombre: key),
          ],
        ),
      );
    });
    return checks;
  }
}

class CheckBoxPermiso extends StatefulWidget {
  const CheckBoxPermiso(
      {Key? key, required this.formController, required this.nombre})
      : super(key: key);

  final UsuarioFormController formController;
  final String nombre;

  @override
  State<CheckBoxPermiso> createState() => _CheckBoxPermisoState();
}

class _CheckBoxPermisoState extends State<CheckBoxPermiso> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.formController.permisosController[widget.nombre],
      shape: const CircleBorder(),
      onChanged: (value) {
        widget.formController.permisosController[widget.nombre] =
            value ?? false;
        setState(() {});
      },
    );
  }
}

class SucursalesFormWidget extends StatelessWidget {
  const SucursalesFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: sucursalesBuilder(context),
          ),
        ),
      ),
    );
  }

  List<Widget> sucursalesBuilder(BuildContext context) {
    final usuarioController = Provider.of<UsuariosController>(context);
    List<Widget> cheks = [];

    usuarioController.sucursales.forEach((key, value) {
      cheks.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(key.nombre)),
            CheckBoxSucursal(
                usuarioController: usuarioController, sucursal: key),
          ],
        ),
      );
    });
    return cheks;
  }
}

class CheckBoxSucursal extends StatefulWidget {
  const CheckBoxSucursal({
    Key? key,
    required this.usuarioController,
    required this.sucursal,
  }) : super(key: key);

  final UsuariosController usuarioController;
  final SucursalModel sucursal;

  @override
  State<StatefulWidget> createState() => _CheckBoxSucursalState();
}

class _CheckBoxSucursalState extends State<CheckBoxSucursal> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.usuarioController.sucursales[widget.sucursal],
      shape: const CircleBorder(),
      onChanged: (value) {
        widget.usuarioController.sucursales[widget.sucursal] = value ?? false;
        setState(() {});
      },
    );
  }
}
