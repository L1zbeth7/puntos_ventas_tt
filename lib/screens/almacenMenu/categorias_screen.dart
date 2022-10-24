import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/screens/screens.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
import 'package:puntos_ventas_tt/widgets/app_bar.dart';

class CategoriasScreen extends StatelessWidget {
  static String routePage = 'CategoriasScreen';
  const CategoriasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final categoriaController = Provider.of<CategoriasController>(context);
    return DoubleBack(
        message: 'Pulsa dos veces para cerrar',
        child: Scaffold(
          appBar: Appbar.AppbarStyle(title: 'Categorias'),
          drawer: DrawerMenu(routeActual: routePage),
          body: Padding(
              padding: const EdgeInsets.all(25),
              child: Stack(
                children: [
                  _PantallaContenido(),
                ],
              )
              // categoriaController.pantallaActiva == 0
              //     ? _PantallaContenido()
              //     : _PantallaFormulario(),
              ),
        ));
  }
}

class _PantallaContenido extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Botones(),
        const SizedBox(height: 25),
        _TablaCategorias(),
      ],
    );
  }
}

class _Botones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final categoriaController = Provider.of<CategoriasController>(context);
    //CategoriaFormController formController = CategoriaFormController();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextButton.icon(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text('Agregar', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(Colors.green),
              onPressed: () {
                // categoriaController.pantallaActiva = 1;
                // categoriaController.valorSwitch = true;
                // formController.limpiarFormulario();
              },
            )),
            const SizedBox(width: 15),
            Expanded(
                child: TextButton.icon(
              icon: const Icon(
                Icons.description_outlined,
                color: Colors.white,
              ),
              label: Text('Reporte', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(const Color(0xff005CB9)),
              onPressed: () {
                print('boton reporte');
                // categoriaController.getReporte();
              },
            ))
          ],
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
                child: TextButton.icon(
              icon: const Icon(Icons.picture_as_pdf_outlined,
                  color: Colors.white),
              label: Text('PDF', style: StyleTexto.styleTextbutton),
              style: StyleTexto.getButtonStyle(Colors.redAccent),
              onPressed: () {
                print('boton pdf');
                // categoriaController.getReporte(buscar: true);
              },
            )),
            const SizedBox(width: 15),
            Flexible(
                child: TextField(
              // controller: formController.buscar,
              decoration: InputDecoration(
                  // suffixIcon: categoriaController.buscarVacio
                  //     ? null
                  //     : IconButton(
                  //         icon: const Icon(Icons.check_circle_outlined,
                  //             color: Colors.green),
                  //         onPressed: () {
                  //           categoriaController.buscarVacio = true;
                  //           FocusScope.of(context).unfocus();
                  //         },
                  //       ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Buscar',
                  labelText: 'Buscar'),
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
            ))
          ],
        )
      ],
    );
  }
}

class _TablaCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final categoriaController = Provider.of<CategoriasController>(context);
    return Expanded(
        child: Container(
      decoration: StyleTexto.boxDecorationCard,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: _crearTabla(context),

                // _crearTabla(
                //     context,
                //     categoriaController.buscarVacio == true
                //         ? categoriaController.categorias
                //         : categoriaController.categoriasBuscar),
              ),
            )),
      ),
    ));
  }
}

List<TableRow> _crearTabla(
  BuildContext context,
  /* List<CategoriaModel> categorias */
) {
  List<TableRow> celdas = [];

  const styleTextColumn = TextStyle(color: Colors.white);
  final boxDecoration = BoxDecoration(
    color: const Color(0xff005CB9),
    border: Border.all(color: Colors.black45),
    borderRadius: BorderRadius.circular(25),
  );

  const boxDecorationCell = BoxDecoration(
      border: Border(
    left: BorderSide(color: Colors.black45),
    right: BorderSide(color: Colors.black45),
  ));

  const boxConstrainst = BoxConstraints(maxWidth: 250);

  celdas.add(
    TableRow(
      decoration: boxDecoration,
      children: [
        TableCell(
            child: Container(
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text('Opciones', style: styleTextColumn),
          ),
        )),
        TableCell(
            child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: boxDecorationCell,
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text('Nombre', style: styleTextColumn),
          ),
        )),
        TableCell(
            child: Container(
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text('Descripción', style: styleTextColumn),
          ),
        )),
        TableCell(
            child: Container(
          decoration: boxDecorationCell,
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text('Porcentaje', style: styleTextColumn),
          ),
        )),
        TableCell(
            child: Container(
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text('Estado', style: styleTextColumn),
          ),
        )),
      ],
    ),
  );

  for (int i = 0; i < 2; i++) {
    final boxDecorationCellConten = BoxDecoration(
      color: i % 2 != 0 ? Colors.white12 : Colors.white,
      borderRadius: i % 2 != 0 ? BorderRadius.circular(25) : null,
    );
    celdas.add(TableRow(decoration: boxDecorationCellConten, children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Row(children: [
              _botonEditar(
                context, /*categorias[i]*/
              ),
              const SizedBox(width: 15),
              _botonEliminar(
                context, /*categorias[i].idCategoria*/
              )
            ]),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          constraints: boxConstrainst,
          padding: const EdgeInsets.all(20),
          child: Center(child: Text('Nombre' /*categorias[i].nombre*/)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          constraints: boxConstrainst,
          padding: const EdgeInsets.all(20),
          child:
              Center(child: Text('Descripcion' /*categorias[i].descripcion*/)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          constraints: boxConstrainst,
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Text('Porcentaje' /*'${categorias[i].porcentaje}'*/)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          constraints: boxConstrainst,
          padding: const EdgeInsets.all(20),
          child: Center(child: _etiquetaActivo(true /*categorias[i].activo*/)),
        ),
      ),
    ]));
  }
  return celdas;
}

_botonEditar(
  BuildContext context,
  /*CategoriaModel categoria*/
) {
  // final categoriaController =
  //     Provider.of<CategoriasController>(context, listen: false);
  // CategoriaFormController formController = CategoriaFormController();

  var roundedRectangleBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)));
  return TextButton(
    style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(roundedRectangleBorder),
        backgroundColor: MaterialStateProperty.all(Colors.orange)),
    child: const Icon(Icons.edit, color: Colors.white),
    onPressed: () {
      // categoriaController.pantallaActiva = 1;
      // categoriaController.valorSwitch = categoria.activo;
      // formController.llenarFormulario(categoria);
    },
  );
}

_botonEliminar(
  BuildContext context,
  /*String idCategoria*/
) {
  var roundedRectangleBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)));
  return TextButton(
    style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(roundedRectangleBorder),
        backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
    child: const Icon(Icons.delete_outlined, color: Colors.white),
    onPressed: () async {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: roundedRectangleBorder,
            title: const Text('Alerta'),
            content: const Text('Seguro que deas eliminar'),
            actions: [
              _cancelButton(context),
              _okButton(
                context, /*idCategoria*/
              ),
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

_okButton(
  BuildContext context,
  /*String id*/
) {
  // final categoriaController =
  //     Provider.of<CategoriasController>(context, listen: false);
  return TextButton(
    child: const Text('Ok'),
    onPressed: () {
      // categoriaController.eliminarCategoria(id);
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
      valor ? 'Activado' : 'Desactivado',
      style: const TextStyle(color: Colors.white),
    ),
  );
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
            child: _FormularioAgregar(),
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
    // final categoriaController = Provider.of<CategoriasController>(context);
    // CategoriaFormController formController = CategoriaFormController();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
              child: TextButton.icon(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            label: Text('Regresar', style: StyleTexto.styleTextbutton),
            style: StyleTexto.getButtonStyle(Colors.red),
            onPressed: () {
              print('boton reporte');
              // categoriaController.pantallaActiva = 0;
            },
          )),
          const SizedBox(width: 25),
          Expanded(
              child: TextButton.icon(
            icon: const Icon(Icons.save_outlined, color: Colors.white),
            label: Text('Guardar', style: StyleTexto.styleTextbutton),
            style: StyleTexto.getButtonStyle(const Color(0xff005CB9)),
            onPressed: () {
              print('boton guardar');
              // if (formController.isValidForm) {
              //   categoriaController.registrarEditarCategoria();
              // }
            },
          ))
        ],
      ),
    );
  }
}

class _FormularioAgregar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // CategoriaFormController formController = CategoriaFormController();
    // final categoriaController = Provider.of<CategoriasController>(context);

    final FocusNode focoNombre = FocusNode();
    final FocusNode focoDescripcion = FocusNode();
    final FocusNode focoPorcentaje = FocusNode();

    return Form(
        // key: formController.formKey,
        child: Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Nueva Categoria', style: StyleTexto.styleTextSubtitle),
          const SizedBox(height: 15),
          //nombre
          TextFormField(
            // controller: formController.nombre,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: StyleTexto.getInputStyle('Nombre de la categoria'),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            focusNode: focoNombre,
            onEditingComplete: () {
              focoNombre.unfocus();
              FocusScope.of(context).requestFocus(focoDescripcion);
            },
            validator: (value) => value == null
                ? 'Debes ingresar un nombre'
                : value.isEmpty
                    ? 'Debes ingrear un nombre'
                    : null,
          ),
          const SizedBox(height: 15),
          //descripcion
          TextFormField(
            // controller: formController.descripcion,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: StyleTexto.getInputStyle('Descripción'),
            textCapitalization: TextCapitalization.sentences,
            focusNode: focoDescripcion,
            onEditingComplete: () {
              focoDescripcion.unfocus();
              FocusScope.of(context).requestFocus(focoPorcentaje);
            },
            validator: (value) => value == null
                ? 'Debes ingresar una descripción'
                : value.isEmpty
                    ? 'Debes ingresar una descripción'
                    : null,
          ),
          //porcentaje
          TextFormField(
            // controller: formController.porcentaje,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType:
                TextInputType.number, //activa el teclado solo numerico
            decoration: StyleTexto.getInputStyle('Porcentaje'),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)'))
            ],
            focusNode: focoPorcentaje,
            onEditingComplete: () {
              focoPorcentaje.unfocus();
              // if (formController.isValidForm) {
              //   categoriaController.registrarEditarCategoria();
              // }
            },
            validator: (value) {
              int? numero = int.tryParse(value!);
              return numero == null
                  ? 'Desbes ingresar un valor mayor a 0'
                  : numero <= 0
                      ? 'Debes ingresar un valor mayor a 0'
                      : null;
            },
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black45),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Activo',
                    style: TextStyle(color: Colors.black54, fontSize: 16)),
                Switch(
                  onChanged: (bool value) {}, value: true,
                  // value: categoriaController.valorSwitch,
                  // onChanged: (bool value) {
                  //   categoriaController.valorSwitch = value;
                  //   formController.activo = value;
                  // },
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
