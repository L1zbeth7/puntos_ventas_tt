import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/colores.dart';
import 'package:puntos_ventas_tt/utils/style_texto.dart';
import 'package:puntos_ventas_tt/widgets/widgets.dart';

class SucursalScreen extends StatelessWidget {
  static String routePage = 'SucursalScreen';
  const SucursalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sucursalController = Provider.of<SucursalesController>(context);

    return DoubleBack(
      message: 'Pulsa dos veces para cerrar',
      child: Scaffold(
        appBar: Appbar.AppbarStyle(title: 'Sucursales'),
        drawer: DrawerMenu(routeActual: routePage),
        body: Stack(children: [
          BackgroundImg(),
          Padding(
            padding: const EdgeInsets.all(25),
            child: sucursalController.pantallaActiva == 0
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
          const SizedBox(height: 25),
          _PantallaTabla(),
        ],
      ),
    );
  }
}

class _BotonespPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sucursalController = Provider.of<SucursalesController>(context);
    SucursalFormController formController = SucursalFormController();

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
                  sucursalController.pantallaActiva = 1;
                  sucursalController.valorSwitch = true;
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
                  sucursalController.getReporte();
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
                  sucursalController.getReporte(buscar: true);
                },
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: TextField(
                controller: formController.buscar,
                decoration: InputDecoration(
                    suffixIcon: sucursalController.buscarVacio
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () {
                              sucursalController.buscarVacio = true;
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
                    sucursalController.buscarVacio = true;
                  } else {
                    sucursalController.buscarVacio = true;
                    sucursalController.buscarSucursal();
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
    final sucursalController = Provider.of<SucursalesController>(context);

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
                  sucursalController.buscarVacio == true
                      ? sucursalController.sucursales
                      : sucursalController.sucursalesBuscar),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _crearTabla(
      BuildContext context, List<SucursalModel> sucursales) {
    List<TableRow> celdas = [];

    final textColumStyle = TextStyle(color: Colores.textColorButton);

    List<SucursalModel> sucursales = List.generate(
      2,
      (index) => SucursalModel(
          direccion: 'direccion',
          email: 'email@gmail.com',
          idSucursal: 'idSucursal',
          nombre: 'nombre',
          telefono: '1234567890'),
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
              child: Text('Dirección', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            decoration: boxDecorationCell,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Telefono', style: textColumStyle),
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Correo', style: textColumStyle),
            ),
          ),
        ),
      ]),
    );

    for (int i = 0; i < sucursales.length; i++) {
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
                  children: [_botonEditar(context, sucursales[i])],
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
                child: Text(sucursales[i].nombre),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(sucursales[i].direccion),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(sucursales[i].telefono),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              constraints: boxConstraints,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(sucursales[i].email),
              ),
            ),
          ),
        ]),
      );
    }
    return celdas;
  }

  _botonEditar(BuildContext context, SucursalModel sucursal) {
    final sucursalController =
        Provider.of<SucursalesController>(context, listen: false);
    SucursalFormController formController = SucursalFormController();
    var roundedRectangleBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)));

    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(roundedRectangleBorder),
          backgroundColor: MaterialStateProperty.all(Colores.warningColor)),
      onPressed: () {
        sucursalController.pantallaActiva = 1;
        formController.llenarFormulario(sucursal);
      },
      child: Icon(Icons.edit, color: Colores.textColorButton),
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
        _BotoncesFormulario(),
      ],
    );
  }
}

class _BotoncesFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sucursalController = Provider.of<SucursalesController>(context);
    SucursalFormController formController = SucursalFormController();

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
                sucursalController.pantallaActiva = 0;
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
                  sucursalController.registrarEditarSucursal();
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
    SucursalFormController formController = SucursalFormController();

    FocusNode focoNombre = FocusNode();
    FocusNode focoDirec = FocusNode();
    FocusNode focoTelef = FocusNode();
    FocusNode focoCorreo = FocusNode();

    return Form(
      key: formController.formKey,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sucursal', style: StyleTexto.styleTextSubtitle),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.nombre,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: StyleTexto.getInputStyle('Nombre de la sucursal'),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              focusNode: focoNombre,
              onEditingComplete: () {
                focoNombre.unfocus();
                FocusScope.of(context).requestFocus(focoDirec);
              },
              validator: (value) => value == null
                  ? 'Ingresa un nombre'
                  : value.isEmpty
                      ? 'Ingresa un nombre'
                      : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.direccion,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: StyleTexto.getInputStyle('Dirección'),
              textCapitalization: TextCapitalization.sentences,
              focusNode: focoDirec,
              onEditingComplete: () {
                focoDirec.unfocus();
                FocusScope.of(context).requestFocus(focoTelef);
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
              focusNode: focoTelef,
              onEditingComplete: () {
                focoTelef.unfocus();
                FocusScope.of(context).requestFocus(focoCorreo);
              },
              validator: (value) {
                int? numero = int.tryParse(value!);

                return numero == null
                    ? 'Ingresa un número de telefono valido'
                    : numero <= 0
                        ? 'Ingresa un número de telefono valido'
                        : null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: formController.correo,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              decoration: StyleTexto.getInputStyle('Correo'),
              focusNode: focoCorreo,
              onEditingComplete: () {
                focoCorreo.unfocus();
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
}
