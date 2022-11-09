import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/controllers/controllers.dart';
import 'package:puntos_ventas_tt/models/models.dart';

class CrearTiendaController extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  TextEditingController nombre = TextEditingController();
  TextEditingController descripcion = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  bool get isValidForm => formKey.currentState?.validate() ?? false;

  Future<void> registrarNuevaTienda() async {
    _isLoading = true;
    notifyListeners();

    var tiendasReference = FirebaseFirestore.instance.collection('Punto-Venta');

    var tiendaDoc = await tiendasReference.add({});

    var sucursalesReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaDoc.id)
        .collection('Sucursal');

    var sucursalDoc = await sucursalesReference.add({});

    var sucursal = SucursalModel(
        nombre: 'Nueva Sucursal',
        direccion: '',
        telefono: '',
        email: '',
        idSucursal: sucursalDoc.id);

    var categoriasReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaDoc.id)
        .collection('Sucursal')
        .doc(sucursalDoc.id)
        .collection('Categoria');

    var categoriaDoc = await categoriasReference.add({});

    var categoria = CategoriaModel(
        activo: true,
        descripcion: 'Venta de productos Agranel',
        idCategoria: categoriaDoc.id,
        nombre: 'Agranel',
        porcentaje: 0);

    await categoriaDoc.update(categoria.toJson());
    await sucursalDoc.update(sucursal.toJson());

    User user = FirebaseAuth.instance.currentUser!;
    var usuarioData = await FirebaseFirestore.instance
        .collection('Drivers')
        .doc(user.uid)
        .get();

    UsuarioFormController usuario = UsuarioFormController();

    usuario.cargo.text = 'Administrador';
    usuario.idUsuario.text = usuarioData['id'];
    usuario.nombre.text = usuarioData['username'];
    if (usuarioData["Contacto"] != null) {
      usuario.contacto1.text = usuarioData["Contacto"]["email"] ?? '';
      usuario.contacto2.text = usuarioData["Contacto"]["telefono"] ?? '';
    }
    if (usuarioData['idTlati'].contains('T-')) {
      usuario.idTlati.text = usuarioData['idTlati'].substring(2);
    } else {
      usuario.idTlati.text = usuarioData['idTlati'];
    }

    usuario.permisosController.forEach((key, value) {
      usuario.permisosController[key] = true;
    });

    await tiendaDoc.update({
      'idTienda': tiendaDoc.id,
      'descripcion': descripcion.text,
      'nombre': nombre.text,
      'Usuarios.${usuario.idUsuario.text}':
          usuario.toJson(sucursales: {sucursal: true})
    });

    var clientesReference = FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaDoc.id)
        .collection('Cliente');

    ClienteFormController formController = ClienteFormController();

    var documetReference = await clientesReference.add({});

    formController.nombre.text = 'Publico General';
    formController.tipoDocumento = '0';
    formController.id.text = documetReference.id;

    await clientesReference
        .doc(formController.id.text)
        .update(formController.toJson);

    _isLoading = false;
    notifyListeners();
  }
}
