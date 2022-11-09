import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/colores.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class TraspasosScreen extends StatelessWidget {
  static String routePage = 'TraspasosScreen';
  const TraspasosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final traspasosController = Provider.of<TraspasosController>(context);
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: Appbar.AppbarStyle(title: 'Traspasos'),
        drawer: DrawerMenu(routeActual: routePage),
        body: Stack(
          children: [
            BackgroundImg(),
            Padding(
              padding: const EdgeInsets.all(25),
              child: traspasosController.pantallaActiva == 0
                  ? _PantallaPrincipal()
                  : _PantallaFormulario(),
            ),
          ],
        ),
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
          const SizedBox(height: 25),
          _Tabla(),
        ],
      ),
    );
  }
}

class _BotonespPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final traspasosController = Provider.of<TraspasosController>(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.add, color: Colores.textColorButton),
                label: const Text('Agregar',
                    style: TextStyle(color: Colors.white)),
                style: StyleTexto.getButtonStyle(Colors.green.shade400),
                onPressed: () {
                  traspasosController.pantallaActiva = 1;
                  traspasosController.sucursalSelect = '0';
                  traspasosController.cantidad.text = '';
                  traspasosController.getSucursales();
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.description_outlined,
                    color: Colores.textColorButton),
                label: const Text('Reporte',
                    style: TextStyle(color: Colors.white)),
                style: StyleTexto.getButtonStyle(Colors.blue.shade500),
                onPressed: () {
                  traspasosController.getReporte();
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
                label: const Text('PDF', style: TextStyle(color: Colors.white)),
                style: StyleTexto.getButtonStyle(Colores.dangerColor),
                onPressed: () {
                  traspasosController.getReporte(buscar: true);
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: TextField(
                controller: traspasosController.buscar,
                decoration: InputDecoration(
                    suffixIcon: traspasosController.buscarVacio
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () {
                              traspasosController.buscarVacio = true;
                              FocusScope.of(context).unfocus();
                            },
                          ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    hintText: 'Buscar',
                    labelText: 'Buscar'),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    traspasosController.buscarVacio = true;
                  } else {
                    traspasosController.buscarVacio = false;
                    traspasosController.buscarTraspasos();
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

class _Tabla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final traspasoController = Provider.of<TraspasosController>(context);
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
                  traspasoController.buscarVacio == true
                      ? traspasoController.traspasos
                      : traspasoController.traspasosBuscar),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<TraspasoModel> traspasos) {
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    List<TraspasoModel> traspasos = List.generate(
      2,
      (index) => TraspasoModel(
        fecha: Timestamp.fromDate(DateTime.now()),
        articulo: ArticuloTraspasoModel(
            idArticulo: 'idArticulo',
            codigo: 'codigo',
            nombre: 'nombre',
            stock: 8),
        estado: true,
        idTraspaso: 'idTraspaso',
        usuario: UsuarioVentaModel(idUsuario: 'idUsuario', nombre: 'nombre'),
        sucursalEntrada:
            SucursalVentaModel(idSucursal: 'idSucursal', nombre: 'nombre'),
        sucursalSalida:
            SucursalVentaModel(idSucursal: 'idSucursal', nombre: 'nombre'),
      ),
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

    const boxDecorationCellLeft = BoxDecoration(
      border: Border(left: BorderSide(color: Colors.black54)),
    );

    const boxConstraints = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(decoration: boxDecoration, children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Opciones', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Sucursal Salida', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Sucursal Entrada', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Usuario', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Articulos', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Codigo', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Cantidad', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCellLeft,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Estado', style: textColumStyle),
            ),
          ),
        ),
      ]),
    );

    for (int i = 0; i < traspasos.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: i % 1 != 0 ? Colors.white12 : Colors.white12,
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
                    if (traspasos[i].estado)
                      _botonEliminar(context, traspasos[i].idTraspaso)
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
              child: Center(
                child: Text(traspasos[i].sucursalSalida.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(traspasos[i].sucursalEntrada.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(traspasos[i].usuario.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(traspasos[i].articulo.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(traspasos[i].articulo.codigo),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('${traspasos[i].articulo.stock}'),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: _etiquetaActivo(traspasos[i].estado),
              ),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }

  _botonEliminar(BuildContext context, String idCategoria) {
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));
    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colors.red)),
      child: const Icon(Icons.delete, color: Colors.white),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: roundedRectangleBorder,
              title: const Text('Alerta'),
              content: const Text('Seguro de cancelar?'),
              actions: [
                _cancelButton(context),
                _okButton(context, idCategoria),
              ],
            );
          },
        );
      },
    );
  }

  _cancelButton(BuildContext context) => TextButton(
        child: const Text('Cancelar'),
        onPressed: () => Navigator.pop(context),
      );

  _okButton(BuildContext context, String id) {
    final traspasoController =
        Provider.of<TraspasosController>(context, listen: false);
    return TextButton(
      child: const Text('Ok'),
      onPressed: () {
        traspasoController.cancelarTraspaso(id);
        Navigator.pop(context);
      },
    );
  }

  _etiquetaActivo(bool valor) {
    return Container(
      decoration: BoxDecoration(
          color: valor ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.all(10),
      child: Text(
        valor ? 'Acaptado' : 'Cancelado',
        style: const TextStyle(color: Colors.white),
      ),
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
    final traspasosController = Provider.of<TraspasosController>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.chevron_left, color: Colores.textColorButton),
              label:
                  const Text('Regresar', style: TextStyle(color: Colors.white)),
              style: StyleTexto.getButtonStyle(Colores.dangerColor),
              onPressed: () {
                traspasosController.pantallaActiva = 0;
              },
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.save_outlined, color: Colores.textColorButton),
              label:
                  const Text('Guardar', style: TextStyle(color: Colors.white)),
              style: StyleTexto.getButtonStyle(Colores.secondaryColor),
              onPressed: () {
                if (traspasosController.isValidForm) {
                  traspasosController.registrarTraspaso();
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
    final traspasoController = Provider.of<TraspasosController>(context);
    return Form(
      key: traspasoController.formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nuevo Traspaso', style: StyleTexto.styleTextSubtitle),
            const SizedBox(height: 15),
            TextFormField(
              controller: traspasoController.sucursalSalida,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: StyleTexto.getInputStyle('Sucursal Salida'),
              textCapitalization: TextCapitalization.words,
              enabled: false,
              validator: (value) => value == null
                  ? 'Ingresa un nombre'
                  : value.isEmpty
                      ? 'Ingresa un valor'
                      : null,
            ),
            const SizedBox(height: 15),
            _dropdownSucursal(context, traspasoController.sucursalesActivas),
            const SizedBox(height: 15),
            // traspasoController.isLoading
            //     ? const CircularProgressIndicator()
            //     :

            _dropdownArticulo(context, traspasoController.articulosTraspaso),
            const SizedBox(height: 15),
            TextFormField(
              controller: traspasoController.cantidad,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: StyleTexto.getInputStyle('Cantidad'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)'))
              ],
              validator: (value) {
                if (traspasoController.articuloSelect == '0') {
                  return 'Selecciona un articulo';
                }
                if (value == null) {
                  return 'Ingresa una cantidad';
                } else {
                  if (value.isEmpty) {
                    return 'Ingresa una cantidad';
                  } else {
                    double cantidad = double.parse(value);
                    if (cantidad > traspasoController.maximo) {
                      return 'No debe ser mayor al stock del producto';
                    }
                    return null;
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _dropdownSucursal(BuildContext context, List<SucursalVentaModel> sucursales) {
    final traspasoController =
        Provider.of<TraspasosController>(context, listen: false);
    return DropdownButtonFormField<String>(
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      value: '0',
      items: getOpcionesDropdown(context, sucursales),
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          label: Text('Categoria')),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value == '0' ? 'Selecciona una categoria' : null,
      onTap: () => FocusScope.of(context).unfocus(),
      onChanged: (value) {
        if (value != '0') {
          traspasoController.getArticulosActivos(value!);
        } else {
          traspasoController.articulosTraspaso = [];
        }
      },
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown(
      BuildContext context, List<SucursalVentaModel> sucursales) {
    final traspasoController =
        Provider.of<TraspasosController>(context, listen: false);
    List<DropdownMenuItem<String>> lista = [];

    if (lista.isNotEmpty) {
      lista = [];
    }

    lista.add(
      const DropdownMenuItem(
        value: '0',
        child: Text('Selecciona una sucursal'),
      ),
    );

    for (var element in sucursales) {
      lista.add(DropdownMenuItem(
        value: element.idSucursal,
        child: Text(element.nombre),
        onTap: () {
          traspasoController.sucursalEntrada = element;
        },
      ));
    }
    return lista;
  }

  _dropdownArticulo(
      BuildContext context, List<ArticuloTraspasoModel> articulos) {
    final traspasoController =
        Provider.of<TraspasosController>(context, listen: false);
    return DropdownButtonFormField<String>(
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      value: '0',
      items: getOpcionesDropdownArticulo(context, articulos),
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          label: Text('Articulo')),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value == '0' ? 'Selecciona un articulo' : null,
      onTap: () => FocusScope.of(context).unfocus(),
      onChanged: (value) {
        traspasoController.articuloSelect = value!;
      },
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdownArticulo(
      BuildContext context, List<ArticuloTraspasoModel> articulos) {
    final traspasoController =
        Provider.of<TraspasosController>(context, listen: false);
    List<DropdownMenuItem<String>> lista = [];

    if (lista.isNotEmpty) {
      lista = [];
    }

    lista.add(const DropdownMenuItem(
      value: '0',
      child: Text('Selecciona un articulo'),
    ));

    for (var element in articulos) {
      lista.add(DropdownMenuItem(
        value: element.idArticulo,
        onTap: () {
          traspasoController.maximo = element.stock as double;
          traspasoController.articuloTraspaso = element;
        },
        child: Text('${element.nombre} - ${element.stock}'),
      ));
    }
    return lista;
  }
}
