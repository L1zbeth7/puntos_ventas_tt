import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/utils.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ArticulosController extends ChangeNotifier {
  bool _isLoading = false;
  int _pantallaActiva = 0;
  bool _valorSwitch = true;
  bool _buscarVacio = true;
  String _imagen = '';
  String _barCode = '';
  String _idArticulo = '';

  List<ArticuloModel> _articulos = [];
  List<ArticuloModel> _articulosBuscar = [];
  List<CategoriaModel> _categoriasActivas = [];
  // List<CategoriaModel> _categoriasBuscar = [];

  final UserPreferencesSecure _userPreferences = UserPreferencesSecure();

  bool get isLoading => _isLoading;

  int get pantallaActiva => _pantallaActiva;

  set pantallaActiva(int value) {
    _pantallaActiva = value;
    notifyListeners();
  }

  bool get valorSwitch => _valorSwitch;

  set valorSwitch(bool value) {
    _valorSwitch = value;
    notifyListeners();
  }

  bool get buscarVacio => _buscarVacio;

  set buscarVacio(bool value) {
    ArticuloFormController formController = ArticuloFormController();
    if (value) formController.buscar.text = '';
    _buscarVacio = value;
    notifyListeners();
  }

  String get imagen => _imagen;
  set imagen(String value) {
    _imagen = value;
    notifyListeners();
  }

  String get barCode => _barCode;
  set barCode(String value) {
    _barCode = value;
    notifyListeners();
  }

  String get idArticulo => _idArticulo;
  set idArticulo(String value) {
    _idArticulo = value;
    notifyListeners();
  }

  Future<bool> get isAdmin async => await _userPreferences.isAdmin();

  List<ArticuloModel> get articulos => _articulos;
  List<ArticuloModel> get articulosBuscar => _articulosBuscar;
  List<CategoriaModel> get categoriasActivas => _categoriasActivas;

  Future<void> getcategoriasActivas() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    _categoriasActivas = [];

    var categoriasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Categoria')
        .where('activo', isEqualTo: true)
        .get();

    for (var element in categoriasReference.docs) {
      _categoriasActivas.add(CategoriaModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getarticulos() async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    _articulos = [];

    var articulosReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo')
        .get();

    for (var element in articulosReference.docs) {
      _articulos.add(ArticuloModel.fromJson(element.data()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarEditarArticulo() async {
    _isLoading = true;
    notifyListeners();

    ArticuloFormController formController = ArticuloFormController();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    var articulosReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo');

    late String idArticulo;

    if (formController.idArticulo.text == '') {
      var documetReference = await articulosReference.add({});
      idArticulo = documetReference.id;

      late CategoriaModel categoria;
      for (var element in categoriasActivas) {
        if (element.idCategoria == formController.idCategoria.text) {
          categoria = element;
          break;
        }
        //print('categoria');
      }

      String imagenUrl = '';

      if (_imagen != '' && _imagen != 'Imagen') {
        var imagenSubida =
            (await uploadFile(File(_imagen), formController.idArticulo.text));
        imagenUrl = await imagenSubida.ref.getDownloadURL();
      }

      formController.idArticulo.text = idArticulo;

      await documetReference
          .update(formController.toJson(categoria, imagenUrl));
    } else {
      late CategoriaModel categoria;
      String imagenUrl = '';
      idArticulo = formController.idArticulo.text;
      var documentReferece = articulosReference.doc(idArticulo);

      for (var element in categoriasActivas) {
        if (element.idCategoria == formController.idCategoria.text) {
          categoria = element;
          break;
        }
      }

      if (imagen.contains('https://')) {
        await documentReferece.update(formController.toJson(categoria, imagen));
      } else if (imagen == '' || imagen == 'Imagen') {
        await documentReferece.update(formController.toJson(categoria, ''));
      } else {
        var imagenSubida = (await uploadFile(File(_imagen), idArticulo));
        imagenUrl = await imagenSubida.ref.getDownloadURL();

        await documentReferece
            .update(formController.toJson(categoria, imagenUrl));
      }
    }

    _valorSwitch = true;
    _pantallaActiva = 0;
    getarticulos();

    _isLoading = false;
    notifyListeners();
  }

  Future<TaskSnapshot> uploadFile(File file, String filename) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('Punto-Venta')
        .child(await _userPreferences.getTiendaId())
        .child(await _userPreferences.getSucursalId())
        .child('Articulos')
        .child('$filename.jpg');

    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    UploadTask uploadTask = ref.putFile(File(file.path), metadata);
    return uploadTask;
  }

  Future<void> eliminarArticulo(String idArticulo) async {
    _isLoading = true;
    notifyListeners();

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();
    var articuloReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo');

    var imageReference = FirebaseStorage.instance
        .ref()
        .child('Punto-Venta')
        .child(await _userPreferences.getTiendaId())
        .child(await _userPreferences.getSucursalId())
        .child('Articulos')
        .child('$idArticulo.jpg');

    await articuloReference.doc(idArticulo).delete();

    try {
      await imageReference.getDownloadURL().then(
        (value) async {
          await imageReference.delete();
        },
      ).catchError((e) {
        //print('El archivo no existe');
        return null;
      }).onError((error, stackTrace) {
        //print('El archivo no existe');
      });
    } catch (e) {
      //print('El archivo no existe');
    }

    getarticulos();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReporte({bool buscar = false}) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    page.graphics.drawString(
        'Articulos', PdfStandardFont(PdfFontFamily.helvetica, 25),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 50));

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: 7);

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Nombre';
    headerRow.cells[1].value = 'Categoria';
    headerRow.cells[2].value = 'Descripcion';
    headerRow.cells[3].value = 'Codigo';
    headerRow.cells[4].value = 'Stock';
    headerRow.cells[5].value = 'Precio Venta';
    headerRow.cells[6].value = 'Estado';

    headerRow.style = PdfGridRowStyle(
      backgroundBrush: PdfSolidBrush(
        PdfColor(
          Colores.secondaryColor.red,
          Colores.secondaryColor.green,
          Colores.secondaryColor.blue,
        ),
      ),
      textBrush: PdfBrushes.white,
    );

    List<ArticuloModel> articulosReporte = _articulos;

    if (buscar == true) articulosReporte = _articulosBuscar;

    for (int i = 0; i < articulosReporte.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = articulosReporte[i].nombre;
      row.cells[1].value = articulosReporte[i].categoria.nombre;
      row.cells[2].value = articulosReporte[i].descripcion;
      row.cells[3].value = articulosReporte[i].codigo;
      row.cells[4].value = articulosReporte[i].stock.toString();
      row.cells[5].value = articulosReporte[i].precioVenta.toString();
      row.cells[6].value =
          articulosReporte[i].activo ? 'Activado' : 'Desactivado';
      row.style = PdfGridRowStyle(
          backgroundBrush: i % 2 != 0
              ? PdfBrushes.white
              : PdfSolidBrush(PdfColor(200, 200, 200)));
    }

    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 60, page.getClientSize().width, page.getClientSize().height),
    );

    Directory appDocDir = await getApplicationDocumentsDirectory();

    if (await File('${appDocDir.path}/Articulos.pdf').exists()) {
      await File('${appDocDir.path}/Articulos.pdf').delete();
    }

    File('${appDocDir.path}/Articulos.pdf').writeAsBytes(await document.save());

    await OpenFile.open('${appDocDir.path}/Articul7os.pdf');

    document.dispose();
  }

  void buscarArticulos() {
    ArticuloFormController formController = ArticuloFormController();
    _articulosBuscar = [];
    for (var element in _articulos) {
      bool nombreArticulo = element.nombre
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      bool nombreCategoria = element.categoria.nombre
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      bool descripcion = element.descripcion
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      bool codigo = element.codigo
          .toLowerCase()
          .contains(formController.buscar.text.toLowerCase());
      double? precioVenta = double.tryParse(formController.buscar.text);
      double? stock = double.tryParse(formController.buscar.text);

      if (nombreArticulo ||
          nombreCategoria ||
          descripcion ||
          codigo ||
          (precioVenta == null
              ? false
              : int.parse(formController.buscar.text) == element.precioVenta) ||
          (stock == null
              ? false
              : int.parse(formController.buscar.text) == element.stock)) {
        _articulosBuscar.add(element);
      }
    }
  }

  void llenarDatos(ArticuloModel articulo) {
    _imagen = articulo.imagen;
    _barCode = articulo.codigo;
    _valorSwitch = articulo.activo;
  }

  void limpiarDatos() {
    _pantallaActiva = 0;
    _valorSwitch = true;
    _imagen = '';
    _barCode = '';
  }

  void llenarDatosAjuste(ArticuloModel articulo) {
    AjusteFormController formController = AjusteFormController();

    User usuario = FirebaseAuth.instance.currentUser!;
    String idUser = usuario.uid;
    String nombreUsuario = usuario.displayName!;

    formController.llenarFormulario(
        idUsuarioA: idUser,
        nombreUsuarioA: nombreUsuario,
        idArticuloA: articulo.idArticulo,
        nombreArticuloA: articulo.nombre,
        stockActual: articulo.stock,
        precioActual: articulo.precioVenta);
  }

  Future<void> registrarAjuste() async {
    _isLoading = true;
    notifyListeners();

    User usuario = FirebaseAuth.instance.currentUser!;
    String idUser = usuario.uid;
    String nombreUsuario = usuario.displayName!;

    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    AjusteFormController formController = AjusteFormController();

    var ajusteReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Ajuste');

    var articuloReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Articulo');

    var docAjusteReference = await ajusteReference.add({});

    String descripcion = '';

    if ((formController.stock != double.parse(formController.stock2.text)) &&
        (formController.precioVenta !=
            double.parse(formController.precioVenta2.text))) {
      descripcion +=
          ' Se ajusto stock de ${formController.stock} a ${double.parse(formController.stock2.text)} y precio venta de ${formController.precioVenta} a ${double.parse(formController.precioVenta2.text)}';
    } else if (formController.stock !=
        double.parse(formController.stock2.text)) {
      descripcion +=
          ' Se ajusto stock de ${formController.stock} a ${double.parse(formController.stock2.text)}';
    } else if (formController.precioVenta !=
        double.parse(formController.precioVenta2.text)) {
      descripcion +=
          ' Se ajusto precio venta de ${formController.precioVenta} a ${double.parse(formController.precioVenta2.text)}';
    }

    articuloReference.doc(formController.idArticulo.text).update(
      {
        "precioVenta": double.parse(formController.precioVenta2.text),
        "stock": double.parse(formController.stock2.text),
      },
    );

    AjusteModel ajuste = AjusteModel(
        articulo: ArticuloAjuste(
            idArticulo: formController.idArticulo.text,
            nombreArticulo: formController.nombreArticulo.text),
        descripcion: descripcion,
        idAjuste: docAjusteReference.id,
        precioVenta: formController.precioVenta,
        stock: formController.stock,
        precioVenta2: double.parse(formController.precioVenta2.text),
        stock2: double.parse(formController.stock2.text),
        usuario: UsuarioAjuste(idUsuario: idUser, nombre: nombreUsuario),
        fecha: Timestamp.fromDate(DateTime.now()));

    docAjusteReference.update(ajuste.toJson());

    getarticulos();

    _isLoading = true;
    notifyListeners();
  }
}
