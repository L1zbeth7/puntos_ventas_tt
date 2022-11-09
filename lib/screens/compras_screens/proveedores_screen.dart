import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/colores.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class ProveedoresScreen extends StatelessWidget {
  static String routePage = 'ProveedoresScreen';
  const ProveedoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final proveedoresController = Provider.of<ProveedoresController>(context);
    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: Appbar.AppbarStyle(title: 'Proveedores'),
        drawer: DrawerMenu(routeActual: routePage),
        body: Stack(children: [
          BackgroundImg(),
          Padding(
              padding: const EdgeInsets.all(25),
              child: proveedoresController.pantallaActiva == 0
                  ? _PantallaPrincipal()
                  : _PantallaFormulario()),
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
          const SizedBox(height: 25),
          _TablaCategorias()
        ],
      ),
    );
  }
}

class _BotonespPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final proveedoresController = Provider.of<ProveedoresController>(context);
    ProveedorFormController formController = ProveedorFormController();

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
                  proveedoresController.pantallaActiva = 1;
                  formController.limpiarFormulario();
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
                  proveedoresController.getReporte();
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
                  proveedoresController.getReporte(buscar: true);
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: TextField(
                controller: formController.buscar,
                decoration: InputDecoration(
                    suffixIcon: proveedoresController.buscarVacio
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () {
                              proveedoresController.buscarVacio = true;
                              FocusScope.of(context).unfocus();
                            }),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Buscar',
                    labelText: 'Buscar'),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    proveedoresController.buscarVacio = true;
                  } else {
                    proveedoresController.buscarVacio = false;
                    proveedoresController.buscarProveedores();
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

class _TablaCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final proveedoresController = Provider.of<ProveedoresController>(context);
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
                  proveedoresController.buscarVacio == true
                      ? proveedoresController.proveedores
                      : proveedoresController.proveedoresBuscar),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<PersonaModel> proveedores) {
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    List<PersonaModel> proveedores = List.generate(
      3,
      (index) => PersonaModel(
          direccion: 'direccion',
          documento: 'Cedula',
          email: 'email@gmail.com',
          id: 'id',
          nombre: 'nombre',
          numeroDocumento: 'numeroDocumento',
          telefono: '1234567890'),
    );

    final boxDecoration = BoxDecoration(
        color: Colores.secondaryColor,
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(15));

    const boxDecorationCell = BoxDecoration(
      border: Border(
          left: BorderSide(color: Colors.black54),
          right: BorderSide(color: Colors.black54)),
    );

    const boxDecorationCellLeft = BoxDecoration(
      border: Border(left: BorderSide(color: Colors.black45)),
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
            constraints: boxConstraints,
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Nombre', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Documento', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Numero Documento', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Telefono', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCellLeft,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Email', style: textColumStyle),
            ),
          ),
        ),
      ]),
    );

    for (int i = 0; i < proveedores.length; i++) {
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
                    _botonEditar(context, proveedores[i]),
                    const SizedBox(width: 15),
                    _botonEliminar(context, proveedores[i].id)
                  ],
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(proveedores[i].nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(proveedores[i].documento),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(proveedores[i].numeroDocumento),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(proveedores[i].telefono),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(proveedores[i].email),
              ),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }

  _botonEditar(BuildContext context, PersonaModel proveedor) {
    final proveedoresController = Provider.of<ProveedoresController>(context);
    ProveedorFormController formController = ProveedorFormController();

    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colores.warningColor)),
      child: const Icon(Icons.edit, color: Colors.white),
      onPressed: () {
        proveedoresController.pantallaActiva = 1;
        formController.llenarFormulario(proveedor);
      },
    );
  }

  _botonEliminar(BuildContext context, String idProveedor) {
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
              content: const Text('Seguro de eliminar?'),
              actions: [
                _cancelButton(context),
                _okButton(context, idProveedor)
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
    final proveedoresController = Provider.of<ProveedoresController>(context);
    return TextButton(
      child: const Text('Ok'),
      onPressed: () {
        proveedoresController.eliminarProveedor(id);
        Navigator.pop(context);
      },
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
    final proveedoresController = Provider.of<ProveedoresController>(context);
    ProveedorFormController formController = ProveedorFormController();

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
                proveedoresController.pantallaActiva = 0;
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
                  proveedoresController.registrarEditarProveedor();
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
    ProveedorFormController formController = ProveedorFormController();

    FocusNode focoNombre = FocusNode();
    FocusNode focoNumeroDocumento = FocusNode();
    FocusNode focoDireccion = FocusNode();
    FocusNode focoTelefono = FocusNode();
    FocusNode focoEmail = FocusNode();

    return Form(
      key: formController.formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ingresa Nuevo Proveedor',
                style: StyleTexto.styleTextSubtitle),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.nombre,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              decoration: StyleTexto.getInputStyle('Nombre del Proveedor'),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              focusNode: focoNombre,
              onEditingComplete: () {
                focoNombre.unfocus();
              },
              validator: (value) => value == null
                  ? 'Ingresa un nombre'
                  : value.isEmpty
                      ? 'Ingresa un nombre'
                      : null,
            ),
            const SizedBox(height: 15),
            _dropdownDocumento(context),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.numeroDocumento,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: StyleTexto.getInputStyle('Numero de documento'),
              textCapitalization: TextCapitalization.characters,
              focusNode: focoNumeroDocumento,
              onEditingComplete: () {
                focoNumeroDocumento.unfocus();
                FocusScope.of(context).requestFocus(focoDireccion);
              },
              validator: (value) => value == null
                  ? 'Ingresa un número'
                  : value.isEmpty
                      ? 'Ingresa un numero'
                      : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.direccion,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.streetAddress,
              decoration: StyleTexto.getInputStyle('Dirección'),
              focusNode: focoDireccion,
              onEditingComplete: () {
                focoDireccion.unfocus();
                FocusScope.of(context).requestFocus(focoTelefono);
              },
              validator: (value) => value == null
                  ? 'Ingresa una dirección'
                  : value.isEmpty
                      ? 'Ingresa una dirección'
                      : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.telefono,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: StyleTexto.getInputStyle('Telefono'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^(\d{0,10})'))
              ],
              focusNode: focoTelefono,
              onEditingComplete: () {
                focoTelefono.unfocus();
                FocusScope.of(context).requestFocus(focoEmail);
              },
              validator: (value) {
                return value!.length != 10 ? 'Ingresa un número valido' : null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.email,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              decoration: StyleTexto.getInputStyle('E-mail'),
              focusNode: focoEmail,
              onEditingComplete: () {
                focoEmail.unfocus();
                if (formController.isValidForm) {}
              },
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo no es valido';
              },
            ),
          ],
        ),
      ),
    );
  }

  _dropdownDocumento(BuildContext context) {
    ProveedorFormController formController = ProveedorFormController();

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colores.textColorButton,
          ),
          value: formController.tipoDocumento,
          items: getOpcionesDropdown(),
          decoration: const InputDecoration(border: InputBorder.none),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) =>
              value == '0' ? 'Selecciona un tipo de documento' : null,
          onTap: () => FocusScope.of(context).unfocus(),
          onChanged: (value) {
            formController.tipoDocumento == value;
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = [];

    if (lista.isNotEmpty) {
      lista = [];
    }

    lista.add(const DropdownMenuItem(
      value: '0',
      child: Text('Selecciona un tipo de documento'),
    ));
    lista.add(const DropdownMenuItem(
      value: 'DNI',
      child: Text('DNI'),
    ));
    lista.add(const DropdownMenuItem(
      value: 'RUC',
      child: Text('RUC'),
    ));
    lista.add(const DropdownMenuItem(
      value: 'Cedula',
      child: Text('Cedula'),
    ));

    return lista;
  }
}
