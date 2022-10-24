import 'package:url_launcher/url_launcher.dart';

class CustomLaunch {
  static void launchWeb(String value) async {
    final web = Uri(
      scheme: 'https',
      path: value,
    );
    launchUrl(web);
  }
}
