import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserPreferencesSecure {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> setTiendaId(String value) async {
    await _storage.write(key: 'idTienda', value: value);
  }

  Future<String> getTiendaId() async {
    return await _storage.read(key: 'idTienda') ?? '';
  }

  Future<void> setNombreTienda(String value) async {
    await _storage.write(key: 'nombreTienda', value: value);
  }

  Future<String> getNombreTienda() async {
    return await _storage.read(key: 'nombreTienda') ?? '';
  }

  Future<void> setSucursalId(String value) async {
    await _storage.write(key: 'idSucursal', value: value);
  }

  Future<String> getSucursalId() async {
    return await _storage.read(key: 'idSucursal') ?? '';
  }

  Future<void> setNombreSucursal(String value) async {
    await _storage.write(key: 'nombreSucursal', value: value);
  }

  Future<String> getNombreSucursal() async {
    return await _storage.read(key: 'nombreSucursal') ?? '';
  }

  Future<void> setCargo(String value) async {
    await _storage.write(key: 'Cargo', value: value);
  }

  Future<String> getCargo() async {
    return await _storage.read(key: 'Cargo') ?? '';
  }

  setPermisos(Map<String, dynamic> permisos) async {
    permisos.forEach((key, value) async {
      switch (key) {
        case 'Escritorio':
          await _storage.write(key: 'Escritorio', value: value ? '1' : '0');
          break;
        case 'Almacen':
          await _storage.write(key: 'Almacen', value: value ? '1' : '0');
          break;
        case 'Compras':
          await _storage.write(key: 'Compras', value: value ? '1' : '0');
          break;
        case 'Ventas':
          await _storage.write(key: 'Ventas', value: value ? '1' : '0');
          break;
        case 'Acceso':
          await _storage.write(key: 'Acceso', value: value ? '1' : '0');
          break;
        case 'Consulta Compras':
          await _storage.write(
              key: 'Consulta Compras', value: value ? '1' : '0');
          break;
        case 'Consulta Ventas':
          await _storage.write(
              key: 'Consulta Ventas', value: value ? '1' : '0');
          break;
      }
    });
  }

  Future<bool> getPermiso(String permiso) async {
    //1 da permisos, 0 quita permisos
    final value = await _storage.read(key: permiso) ?? '1'; //0
    return value == '1' ? true : false;
  }

  Future<bool> isAdmin() async {
    bool pescritorio = await getPermiso('Escritorio');
    bool palmacen = await getPermiso('Almacen');
    bool pcompras = await getPermiso('Compras');
    bool pventas = await getPermiso('Ventas');
    bool pacceso = await getPermiso('Acceso');
    bool pconsultac = await getPermiso('Consulta Compras');
    bool pconsultav = await getPermiso('Consulta Ventas');
    return (pescritorio &&
        palmacen &&
        pcompras &&
        pventas &&
        pacceso &&
        pconsultac &&
        pconsultav);
  }

  setNumVenta(int value) async {
    var hoy = DateTime.now();
    String fecha = '${hoy.year}-${hoy.month}-${hoy.day}';
    await _storage.write(key: 'numVenta', value: '$value:$fecha');
  }

  Future<int> getNumVenta() async {
    var hoy = DateTime.now();
    String fecha = '${hoy.year}-${hoy.month}-${hoy.day}';
    var numVenta = await _storage.read(key: 'numVenta');
    if (numVenta == null) {
      _storage.write(key: 'numVenta', value: '1:$hoy');

      return 1;
    } else {
      var fechaUltimaV = numVenta.split(':');
      if (fecha != fechaUltimaV[1]) {
        await _storage.write(key: 'numVenta', value: '1:$hoy');
        return 1;
      } else {
        return int.parse(fechaUltimaV[0]);
      }
    }
  }

  Future<void> setDireccionSucursal(String value) async {
    await _storage.write(key: 'direccionSucursal', value: value);
  }

  Future<String> getDireccionSucursal() async {
    return await _storage.read(key: 'direccionSucursal') ?? '';
  }
}
