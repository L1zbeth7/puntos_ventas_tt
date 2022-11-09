import 'package:puntos_ventas_tt/utils/utils.dart';

class UserPreferences {
  static final UserPreferences _instancia = UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  late SharedPreferences _prefs;

  initPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get checkForm {
    return _prefs.getBool('checkForm') ?? false;
  }

  set checkForm(bool value) {
    _prefs.setBool('checkForm', value);
  }

  String get tipo {
    return _prefs.getString('tipo') ?? '';
  }

  set tipo(String value) {
    _prefs.setString('tipo', value);
  }

  String get subtipo {
    return _prefs.getString('subtipo') ?? '';
  }

  set subtipo(String value) {
    _prefs.setString('subtipo', value);
  }

  String get tipoLocalizacion {
    return _prefs.getString('tipoLocalizacion') ?? '';
  }

  set tipoLocalizacion(String value) {
    _prefs.setString('tipoLocalizacion', value);
  }
}
