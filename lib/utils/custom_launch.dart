import 'package:url_launcher/url_launcher.dart';

class CustomLaunch {
  static void launchWeb(String value) async {
    final web = Uri(
      scheme: 'https',
      path: value,
    );
    launchUrl(web);
  }

  static void launchLlamada(String numero) async {
    final llamada = Uri(
      scheme: 'tel',
      path: numero,
    );
    // if (await canLaunchUrl(llamada))
    launchUrl(llamada);
  }

  static void launchCorreo(String email) async {
    final correo = Uri(
      scheme: 'mailto',
      path: email,
    );
    // if (await canLaunchUrl(correo))
    launchUrl(correo);
  }
}
