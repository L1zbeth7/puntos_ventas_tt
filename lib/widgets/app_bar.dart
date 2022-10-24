import 'package:flutter/material.dart';

class Appbar {
  // ignore: non_constant_identifier_names
  static AppBar AppbarStyle({required String title}) => AppBar(
        centerTitle: true,
        title: Text(title),
        backgroundColor: Colors.black,
      );
}
