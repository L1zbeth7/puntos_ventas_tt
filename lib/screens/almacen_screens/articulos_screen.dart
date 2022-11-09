import 'dart:io';
import 'dart:ui' as ui;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/almacen_controllers/almacen_controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/screens/rutas.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class ArticulosScreen extends StatelessWidget {
  static String routePage = 'ArticulosScreen';
  const ArticulosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articulosController = Provider.of<ArticulosController>(context);
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        //appBar: Appbar.AppbarStyle(title: 'Articulos'),
        drawer: DrawerMenu(routeActual: routePage),
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              centerTitle: true,
              title: Text('Articulos'),
              // titleTextStyle: TextStyle(
              //   fontStyle: FontStyle.italic,
              //   fontWeight: FontWeight.bold,
              //   fontSize: 19,
              // ),
              backgroundColor: Colors.black,
              floating: true,
              pinned: false,
              snap: true,
              //flexibleSpace: Placeholder(),  agregar imagen
            ),
            SliverFillRemaining(
              child: Stack(children: [
                BackgroundImg(),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: articulosController.pantallaActiva == 0
                      ? _PantallaPrincipal()
                      : articulosController.pantallaActiva == 1
                          ? _PantallaFormulario()
                          : _AjusteForm(),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     final articulosController = Provider.of<ArticulosController>(context);
//     return DoubleBack(
//       message: 'Pulsa dos veces para cerrar',
//       child: Scaffold(
//         appBar: Appbar.AppbarStyle(title: 'Articulos'),
//         drawer: DrawerMenu(routeActual: routePage),
//         body: Stack(
//           children: [
//             BackgroundImg(),
//             Padding(
//               padding: const EdgeInsets.all(25),
//               child: articulosController.pantallaActiva == 0
//                   ? _PantallaPrincipal()
//                   : articulosController.pantallaActiva == 1
//                       ? _PantallaFormulario()
//                       : _AjusteForm(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //de arriba hacia abajo
      scrollDirection: Axis.vertical,
      //desplazamiento que rebota desde el borde
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _BotonespPrincipal(),
          const SizedBox(height: 25),
          _TablaMostrar(),
        ],
      ),
    );
  }
}

// class _PantallaPrincipal extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _BotonespPrincipal(),
//         const SizedBox(height: 25),
//         _TablaMostrar(),
//       ],
//     );
//   }
// }

class _BotonespPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articulosController = Provider.of<ArticulosController>(context);
    ArticuloFormController formController = ArticuloFormController();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.add, color: Colores.textColorButton),
                label: const Text('Agregar',
                    style: TextStyle(color: Colors.white)),
                style: StyleTexto.getButtonStyle(Colores.successColor),
                onPressed: () {
                  articulosController.pantallaActiva = 1;
                  articulosController.valorSwitch = true;
                  articulosController.imagen = '';
                  articulosController.barCode = '';
                  articulosController.idArticulo = '';
                  articulosController.getcategoriasActivas();
                  formController.limpiarFormulario();
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
                style: StyleTexto.getButtonStyle(Colors.blue.shade600),
                onPressed: () {
                  articulosController.getReporte();
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
                  articulosController.getReporte(buscar: true);
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: TextField(
                controller: formController.buscar,
                decoration: InputDecoration(
                  suffixIcon: articulosController.buscarVacio
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.check_circle_outlined),
                          onPressed: () {
                            articulosController.buscarVacio = true;
                            FocusScope.of(context).unfocus();
                          },
                        ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  hintText: 'Buscar',
                  labelText: 'Buscar',
                ),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    articulosController.buscarVacio = true;
                  } else {
                    articulosController.buscarVacio = true;
                    articulosController.buscarArticulos();
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

class _TablaMostrar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articulosController = Provider.of<ArticulosController>(context);
    return Container(
      decoration: StyleTexto.boxDecorationCard,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        //crea desplazamiento
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(), //desplazamiento que rebota desde el borde
          child: SingleChildScrollView(
            //de izquierda a derecha
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: _crearTabla(
                  context,
                  articulosController.buscarVacio == true
                      ? articulosController.articulos
                      : articulosController.articulosBuscar),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<ArticuloModel> articulos) {
    List<TableRow> celdas = [];

    const textColumStyle = TextStyle(color: Colors.white, fontSize: 16);

    List<ArticuloModel> articulos = List.generate(
        10,
        (index) => ArticuloModel(
            activo: true,
            categoria: CategoriaModel(
                activo: true,
                descripcion: 'descripcion',
                idCategoria: 'idCategoria',
                nombre: 'nombre',
                porcentaje: 10),
            descripcion: 'descripcion',
            nombre: 'nombre',
            codigo: 'codigo',
            idArticulo: 'idArticulo',
            imagen: '',
            precioVenta: 135.6,
            stock: 8.6));

    final boxDecoration = BoxDecoration(
      color: Colores.secondaryColor,
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(15),
    );

    const boxDecorationCell = BoxDecoration(
      border: Border(
        left: BorderSide(color: Colors.black54),
        right: BorderSide(color: Colors.black54),
      ),
    );

    const boxConstraints = BoxConstraints(maxWidth: 250);

    celdas.add(
      TableRow(decoration: boxDecoration, children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20), //tamaño celda
            child: const Center(child: Text('Opciones', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: const Center(child: Text('Nombre', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child:
                const Center(child: Text('Categoria', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child:
                const Center(child: Text('Descripcion', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Center(child: Text('Codigo', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: const Center(child: Text('Stock', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Center(
                child: Text('Precio Venta', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: const Center(child: Text('Imagen', style: textColumStyle)),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Center(child: Text('Estado', style: textColumStyle)),
          ),
        ),
      ]),
    );

    for (int i = 0; i < articulos.length; i++) {
      final boxDecorationCellConten = BoxDecoration(
        color: 1 % 2 != 0 ? Colors.white12 : Colors.black12,
        borderRadius: i % 1 != 0 ? BorderRadius.circular(25) : null,
      );
      celdas.add(
        TableRow(decoration: boxDecorationCellConten, children: [
          TableCell(
            //Aliena los valores dentro de la tabla
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Row(
                  children: [
                    _botonEditar(context, articulos[i]),
                    const SizedBox(width: 15),
                    _botonEliminar(context, articulos[i].idArticulo),
                    const SizedBox(width: 15),
                    _botonAjustar(context, articulos[i]),
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
                child: Text(articulos[i].nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].categoria.nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].descripcion),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(articulos[i].codigo),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('${articulos[i].stock}'),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('${articulos[i].precioVenta}'),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              height: 90,
              width: 90,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: CustomFadeImageNetwork(imageUrl: articulos[i].imagen),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: _etiquetaActivo(articulos[i].activo),
              ),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }

  _botonEditar(BuildContext context, ArticuloModel articulo) {
    final articuloController =
        Provider.of<ArticulosController>(context, listen: false);
    ArticuloFormController formController = ArticuloFormController();

    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));
    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colors.orange)),
      child: const Icon(Icons.edit_outlined, color: Colors.white),
      onPressed: () {
        articuloController.getcategoriasActivas();
        articuloController.pantallaActiva = 1;
        formController.llenarFormulario(articulo);
        articuloController.llenarDatos(articulo);
        articuloController.idArticulo = articulo.idArticulo;
      },
    );
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
      onPressed: () async {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: roundedRectangleBorder,
              title: const Text('Alerta'),
              content: const Text('Seguro de eliminar'),
              actions: [
                _cancelButton(context),
                _okButton(context, idCategoria)
              ],
            );
          },
        );
      },
    );
  }

  _botonAjustar(BuildContext context, ArticuloModel articulo) {
    final articuloController =
        Provider.of<ArticulosController>(context, listen: false);

    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));
    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(const Color(0xff005CB9))),
      child: const Icon(Icons.build_circle_outlined, color: Colors.white),
      onPressed: () {
        articuloController.pantallaActiva = 2;
        articuloController.llenarDatosAjuste(articulo);
      },
    );
  }

  TextButton _cancelButton(BuildContext context) => TextButton(
        child: const Text('Cancelar'),
        onPressed: () => Navigator.pop(context),
      );

  TextButton _okButton(BuildContext context, String id) {
    final articuloController = Provider.of<ArticulosController>(context);
    return TextButton(
      child: const Text('Ok'),
      onPressed: () {
        Navigator.pop(context);
        articuloController.eliminarArticulo(id);
      },
    );
  }

  _etiquetaActivo(bool valor) {
    return Container(
      decoration: BoxDecoration(
          color: valor ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.all(10),
      child: Text(valor ? 'Activado' : 'Desactivado',
          style: const TextStyle(color: Colors.white)),
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

class _Formulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articulosController = Provider.of<ArticulosController>(context);
    ArticuloFormController formController = ArticuloFormController();

    FocusNode focoNombre = FocusNode();
    FocusNode focoCategoria = FocusNode();
    FocusNode focoDescripcion = FocusNode();
    FocusNode focoStock = FocusNode();
    FocusNode focoPrecioVenta = FocusNode();
    FocusNode focoCodigo = FocusNode();

    return Form(
      key: formController.formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nuevo Producto', style: StyleTexto.styleTextSubtitle),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.nombre,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: StyleTexto.getInputStyle('Nombre del producto'),
              textCapitalization: TextCapitalization.words, //pone mayusculas a
              focusNode: focoNombre,
              onEditingComplete: () {
                focoNombre.unfocus();
                FocusScope.of(context).requestFocus(focoCategoria);
              },
              validator: (value) => value == null
                  ? 'Inserte un nombre'
                  : value.isEmpty
                      ? 'Inserte un nombre'
                      : null,
            ),
            const SizedBox(height: 15),
            _dropdownCategoria(context, articulosController.categoriasActivas),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.descripcion,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: StyleTexto.getInputStyle('Descripción'),
              textCapitalization:
                  TextCapitalization.sentences, //pone letras mayusculas
              focusNode: focoDescripcion,
              onEditingComplete: () {
                focoDescripcion.unfocus();
                FocusScope.of(context).requestFocus(focoStock);
              },
              validator: (value) => value == null
                  ? 'Ingresa una descripción'
                  : value.isEmpty
                      ? 'Ingresa una descripción'
                      : null,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: formController.stock,
                    enabled:
                        articulosController.idArticulo == '' ? true : false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number, //activa el teclado num.
                    decoration: StyleTexto.getInputStyle('Stock'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,3}')),
                    ],
                    focusNode: focoStock,
                    onEditingComplete: () {
                      focoStock.unfocus();
                      FocusScope.of(context).requestFocus(focoPrecioVenta);
                    },
                    validator: (value) {
                      //rebisar
                      double? numero = double.tryParse(value ?? '0');

                      if (numero == 0) {
                        return 'Inserte un numero mayor a 0';
                      } else if (value == null) {
                        return 'Inserte un numero mayor a 0';
                      }

                      return numero == null
                          ? 'Inserte un numero mayor a 0'
                          : numero <= 0
                              ? 'Inserte un numero mayor a 0'
                              : null;
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: TextFormField(
                    controller: formController.precioVenta,
                    enabled:
                        articulosController.idArticulo == '' ? true : false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    decoration: StyleTexto.getInputStyle('Precio Venta'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    focusNode: focoPrecioVenta,
                    onEditingComplete: () {
                      focoPrecioVenta.unfocus();
                      FocusScope.of(context).requestFocus(focoCodigo);
                    },
                    validator: (value) {
                      if (value == 0) {
                        return 'Inserte un numero mayor a 0';
                      } else if (value == null) {
                        return 'Inserte un numero mayor a 0';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _BotonImagen(),
            const SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: formController.codigo,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: StyleTexto.getInputStyle('Codigo'),
                    textCapitalization: TextCapitalization.sentences,
                    focusNode: focoCodigo,
                    onEditingComplete: () {
                      focoCodigo.unfocus();
                      FocusScope.of(context).unfocus();
                    },
                    validator: (value) => value == null
                        ? 'Ingresa un codigo'
                        : value.isEmpty
                            ? 'Inserta un codigo'
                            : null,
                    onChanged: (value) {
                      articulosController.barCode = value;
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black26,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () => _escanerCamara(context),
                  ),
                ),
              ],
            ),
            if (articulosController.barCode != '') const SizedBox(height: 15),
            if (articulosController.barCode != '') _BarCode(),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Activo',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                  Switch(
                      value: articulosController.valorSwitch,
                      onChanged: (bool value) {
                        articulosController.valorSwitch = value;
                        formController.activo = value;
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _dropdownCategoria(BuildContext context, List<CategoriaModel> categorias) {
    ArticuloFormController formController = ArticuloFormController();
    return DropdownButtonFormField<String>(
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
      value: '0',
      items: getOpcionesDropdown(categorias),
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          label: Text('Categoria')),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value == 0 ? 'Selecciona la categoria' : null,
      onTap: () => FocusScope.of(context).unfocus(),
      onChanged: (value) {
        formController.idCategoria.text = value ?? '0';
      },
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown(
      List<CategoriaModel> categorias) {
    List<DropdownMenuItem<String>> lista = [];

    if (lista.isNotEmpty) {
      lista = [];
    }

    lista.add(
      const DropdownMenuItem(
        value: '0',
        child: Text('Selecciona la categoria'),
      ),
    );
    for (var element in categorias) {
      lista.add(
        DropdownMenuItem(
          value: element.idCategoria,
          child: Text(element.nombre),
        ),
      );
    }
    return lista;
  }

  Future<void> _escanerCamara(BuildContext context) async {
    FocusScope.of(context).unfocus();
    ArticuloFormController formController = ArticuloFormController();
    final articuloController =
        Provider.of<ArticulosController>(context, listen: false);
    String barCodeScanres = await FlutterBarcodeScanner.scanBarcode(
        '#3d8BEF', 'Cancelar', false, ScanMode.BARCODE);
    if (barCodeScanres != '-1') {
      formController.codigo.text = barCodeScanres;
      articuloController.barCode = barCodeScanres;
    } else {
      formController.codigo.text = '';
      articuloController.barCode = '';
    }
  }
}

class _BotonesFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ArticuloFormController formController = ArticuloFormController();
    final articulosController = Provider.of<ArticulosController>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.chevron_left, color: Colores.textColorButton),
              label:
                  const Text('Regresar', style: TextStyle(color: Colors.white)),
              style: StyleTexto.getButtonStyle(Colors.redAccent),
              onPressed: () {
                articulosController.pantallaActiva = 0;
              },
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: TextButton.icon(
              icon: const Icon(Icons.save_outlined, color: Colors.white),
              label:
                  const Text('Guardar', style: TextStyle(color: Colors.white)),
              style: StyleTexto.getButtonStyle(const Color(0xff005CB9)),
              onPressed: () {
                if (formController.isValidForm) {
                  articulosController.registrarEditarArticulo();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BarCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articuloController = Provider.of<ArticulosController>(context);
    GlobalKey globalKey = GlobalKey();

    return Column(
      children: [
        RepaintBoundary(
          key: globalKey,
          child: Column(
            children: [
              Container(height: 15, color: Colors.white),
              BarcodeWidget(
                backgroundColor: Colors.white,
                barcode: Barcode.code128(),
                data: articuloController.barCode,
                width: double.infinity,
                height: 160,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                textPadding: 15,
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        TextButton.icon(
          icon: const Icon(Icons.file_download_outlined, color: Colors.white),
          label: const Text('Decargar', style: TextStyle(color: Colors.white)),
          style: StyleTexto.getButtonStyle(Colors.green),
          onPressed: () {
            openPicture(globalKey, articuloController.barCode);
          },
        ),
      ],
    );
  }

  Future<void> openPicture(GlobalKey key, String nameImage) async {
    final directory = (await getApplicationDocumentsDirectory()).path;

    RenderRepaintBoundary boundary =
        // ignore: use_build_context_synchronously
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    File imgFile = File('$directory/$nameImage.png');
    if (await imgFile.exists()) {
      await imgFile.delete();
    }
    imgFile.create();

    ui.Image image = await boundary.toImage(pixelRatio: 3);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    imgFile.writeAsBytes(pngBytes);
    await OpenFile.open('$directory/$nameImage.png');
  }
}

class _BotonImagen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articuloController = Provider.of<ArticulosController>(context);
    ArticuloFormController formController = ArticuloFormController();

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    _selectorImagen(context, formController.imagen);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Imagen',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              if (articuloController.imagen != '' &&
                  articuloController.imagen != 'Imagen')
                const SizedBox(width: 15),
              if (articuloController.imagen != '' &&
                  articuloController.imagen != 'Imagen')
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colores.backgroundCardColor),
                  child: IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      formController.imagen = '';
                      articuloController.imagen = '';
                    },
                  ),
                ),
            ],
          ),
          if (articuloController.imagen != '' &&
              articuloController.imagen != 'Imagen')
            const SizedBox(width: 15),
          if (articuloController.imagen != '' &&
              articuloController.imagen != 'Imagen')
            Container(
              width: (MediaQuery.of(context).size.width / 2),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: articuloController.imagen.contains('https://')
                    ? CustomFadeImageNetwork(
                        imageUrl: articuloController.imagen)
                    : FadeInImage(
                        placeholder:
                            AssetImage('${Rutas.imageRute}image-loading.gif'),
                        image: FileImage(File(articuloController.imagen)),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
        ],
      ),
    );
  }

  _selectorImagen(BuildContext context, String imagenAnterior) {
    ArticuloFormController formController = ArticuloFormController();
    final articuloController =
        Provider.of<ArticulosController>(context, listen: false);

    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: roundedRectangleBorder,
          title: const Text('Selecciona origen de la imagen'),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.image_outlined, color: Colors.white),
              label:
                  const Text('Galeria', style: TextStyle(color: Colors.white)),
              style: StyleTexto.getButtonStyle(const Color(0xff005CB9)),
              onPressed: () async {
                String imagenAnterior = formController.imagen;
                articuloController.imagen = '';
                if (await _getImagen(context, ImageSource.gallery) == false) {
                  articuloController.imagen = imagenAnterior;
                  formController.imagen = imagenAnterior;
                }
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
              label:
                  const Text('Camara', style: TextStyle(color: Colors.white)),
              style: StyleTexto.getButtonStyle(const Color(0xff005CB9)),
              onPressed: () async {
                String imagenAnterior = formController.imagen;
                formController.imagen = '';
                articuloController.imagen = '';
                if (await _getImagen(context, ImageSource.camera) == false) {
                  articuloController.imagen = imagenAnterior;
                  formController.imagen = imagenAnterior;
                }
              },
            ),
          ],
        );
      },
    );
  }

  _getImagen(BuildContext context, ImageSource imageSource) async {
    ArticuloFormController formController = ArticuloFormController();
    var articuloController =
        Provider.of<ArticulosController>(context, listen: false);
    //selecciona la imagen de la galeria
    XFile? selectImage = await ImagePicker().pickImage(source: imageSource);
    //comprabar que la imagen seleccionada no sea vacia
    if (selectImage == null) {
      formController.imagen = '';
      articuloController.imagen = '';
      return false;
    } else {
      formController.imagen = selectImage.path;
      articuloController.imagen = selectImage.path;
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}

class _AjusteForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: StyleTexto.boxDecorationCard,
          margin: const EdgeInsets.only(bottom: 60),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _FormularioAjuste(),
          ),
        ),
        _BotonesAjuste(),
      ],
    );
  }
}

class _FormularioAjuste extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AjusteFormController formController = AjusteFormController();

    FocusNode focoDescripcion = FocusNode();
    FocusNode focoStock = FocusNode();
    FocusNode focoPrecio = FocusNode();

    return Form(
      key: formController.formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ajustar Producto', style: StyleTexto.styleTextSubtitle),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.nombreUsuario,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: StyleTexto.getInputStyle('Usuario responsable'),
              textCapitalization: TextCapitalization.words,
              enabled: false,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.nombreArticulo,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: StyleTexto.getInputStyle('Articulo'),
              textCapitalization: TextCapitalization.sentences,
              enabled: false,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.descripcion,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: StyleTexto.getInputStyle('Descripcion'),
              textCapitalization: TextCapitalization.sentences,
              focusNode: focoDescripcion,
              onEditingComplete: () {
                focoDescripcion.unfocus();
                FocusScope.of(context).requestFocus(focoStock);
              },
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: formController.stock2,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    decoration: StyleTexto.getInputStyle('Stock'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,3}'))
                    ],
                    focusNode: focoStock,
                    onEditingComplete: () {
                      focoStock.unfocus();
                      FocusScope.of(context).requestFocus(focoPrecio);
                    },
                    validator: (value) {
                      if (value == '' &&
                          formController.precioVenta2.text == '') {
                        return 'Ingresa un valor';
                      }
                      if (double.parse(formController.stock2.text) ==
                              formController.stock &&
                          double.parse(formController.precioVenta2.text) ==
                              formController.precioVenta) {
                        return 'Cambiar un campo';
                      }
                      double? numero = double.tryParse(value!);
                      return numero == null
                          ? 'Ingresa un numero mayor a 0'
                          : numero <= 0
                              ? 'Ingresa un numero mayor a 0'
                              : null;
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: TextFormField(
                    controller: formController.precioVenta2,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    decoration: StyleTexto.getInputStyle('Precio Venta'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    focusNode: focoPrecio,
                    onEditingComplete: () {
                      focoPrecio.unfocus();
                    },
                    validator: (value) {
                      if (value == '' &&
                          formController.precioVenta2.text == '') {
                        return 'Ingresa un valor';
                      }
                      if (double.parse(formController.stock2.text) ==
                              formController.stock &&
                          double.parse(formController.precioVenta2.text) ==
                              formController.precioVenta) {
                        return 'Cambiar un campo';
                      }
                      double? numero = double.tryParse(value!);
                      return numero == null
                          ? 'Ingresa un numero mayor a 0'
                          : numero <= 0
                              ? 'Ingresa un numero mayor a 0'
                              : null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonesAjuste extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articulosController = Provider.of<ArticulosController>(context);
    AjusteFormController formController = AjusteFormController();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.chevron_left, color: Colores.textColorButton),
              label:
                  const Text('Regresar', style: TextStyle(color: Colors.white)),
              style: StyleTexto.getButtonStyle(Colors.redAccent),
              onPressed: () {
                articulosController.pantallaActiva = 0;
              },
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.save_outlined, color: Colores.textColorButton),
              label:
                  const Text('Guardar', style: TextStyle(color: Colors.white)),
              style: StyleTexto.getButtonStyle(const Color(0xff005CB9)),
              onPressed: () {
                if (formController.isValidForm) {
                  articulosController.registrarAjuste();
                  articulosController.pantallaActiva = 0;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
