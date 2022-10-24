import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:puntos_ventas_tt/models/escritorio_models/venta_model.dart';
import 'package:puntos_ventas_tt/models/models.dart';
import 'package:puntos_ventas_tt/utils/user_preferences_secure.dart';

class EscritorioController extends ChangeNotifier {
  // final LoginService _loginService = LoginService();
  final UserPreferencesSecure _userPreferences = UserPreferencesSecure();

  final _format = DateFormat("yyyy-MM-dd");
  final _formatMes = DateFormat("MM");

  bool _isLoading = false;

  double comprasHoy = 0.0;
  double ventasHoy = 0.0;

  List<ComprasVentasModel> comprasDias = [];
  List<ComprasVentasModel> ventasMeses = [];

  final _meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  bool get isLoading => _isLoading;

  void get consultasEscritorio {
    consultaCompras;
    consultaVentas;
  }

  Future<void> get consultaCompras async {
    _isLoading = true;
    notifyListeners();
    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    List<CompraModel> compras = [];
    comprasDias = [];
    comprasHoy = 0;

    Map<String, double> comprasPorDias = {};

    var fechaHoy = DateTime.now();
    var fechaHoyFormat = _format.format(fechaHoy);
    var fechaAntes = DateTime(fechaHoy.year, fechaHoy.month, fechaHoy.day)
        .subtract(const Duration(days: 10));

    var comprasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Ingreso')
        .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fechaHoy))
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(fechaAntes))
        .where('activo', isEqualTo: true)
        .get();

    for (var element in comprasReference.docs) {
      compras.add(CompraModel.fromJson(element.data()));
    }

    for (var compra in compras) {
      var fechacompraFormat = _format.format(compra.fecha.toDate());

      if (fechacompraFormat == fechaHoyFormat) {
        comprasHoy += compra.totalcompra;
      }

      comprasPorDias[_format.format(compra.fecha.toDate())] =
          comprasPorDias[_format.format(compra.fecha.toDate())] ??
              0 + compra.totalcompra;

      comprasPorDias.forEach((key, value) =>
          comprasDias.add(ComprasVentasModel(fecha: key, total: value)));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> get consultaVentas async {
    _isLoading = true;
    notifyListeners();
    String tiendaSelect = await _userPreferences.getTiendaId();
    String sucursalSelect = await _userPreferences.getSucursalId();

    List<VentaModel> ventas = [];
    ventasMeses = [];

    var fechaHoy = DateTime.now();
    var fechaMenos = DateTime(fechaHoy.year - 1, fechaHoy.month, 1);

    var ventasReference = await FirebaseFirestore.instance
        .collection('Punto-Venta')
        .doc(tiendaSelect)
        .collection('Sucursal')
        .doc(sucursalSelect)
        .collection('Venta')
        .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fechaHoy))
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(fechaMenos))
        .where('activo', isEqualTo: true)
        .get();

    for (var element in ventasReference.docs) {
      ventas.add(VentaModel.fromJson(element.data()));
    }

    ventasHoy = 0;
    ventasMeses = [];
    for (var element in _meses) {
      ventasMeses.add(ComprasVentasModel(fecha: element, total: 0));
    }

    for (var venta in ventas) {
      //ventas por fecha
      var fechaVentaFormat = _format.format(venta.fecha.toDate());
      var fechaHoyFormat = _format.format(fechaHoy);
      if (fechaVentaFormat == fechaHoyFormat) {
        ventasHoy += venta.totalVenta;
      }
      //ventas por mes
      var fechaVentaMes = _formatMes.format(venta.fecha.toDate());
      switch (fechaVentaMes) {
        case '01':
          ventasMeses[0].total += venta.totalVenta;
          break;
        case '02':
          ventasMeses[1].total += venta.totalVenta;
          break;
        case '03':
          ventasMeses[2].total += venta.totalVenta;
          break;
        case '04':
          ventasMeses[3].total += venta.totalVenta;
          break;
        case '05':
          ventasMeses[4].total += venta.totalVenta;
          break;
        case '06':
          ventasMeses[5].total += venta.totalVenta;
          break;
        case '07':
          ventasMeses[6].total += venta.totalVenta;
          break;
        case '08':
          ventasMeses[7].total += venta.totalVenta;
          break;
        case '09':
          ventasMeses[8].total += venta.totalVenta;
          break;
        case '10':
          ventasMeses[9].total += venta.totalVenta;
          break;
        case '11':
          ventasMeses[10].total += venta.totalVenta;
          break;
        case '12':
          ventasMeses[11].total += venta.totalVenta;
          break;
      }
    }

    for (int i = ventasMeses.length - 1; i >= 0; i--) {
      if (ventasMeses[i].total == 0) {
        ventasMeses.removeAt(i);
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
