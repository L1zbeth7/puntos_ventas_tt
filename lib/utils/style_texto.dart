import 'package:flutter/material.dart';

//se usara para darle el mismo tamaño y color al texto
class StyleTexto {
  static get styleTextTitle =>
      const TextStyle(fontSize: 22, color: Colors.white);

  static get styleTextSubtitle =>
      const TextStyle(fontSize: 20, color: Colors.white);

  static get styleTextbutton =>
      const TextStyle(fontSize: 18, color: Colors.black);

  static get styleLabelForm =>
      const TextStyle(fontSize: 20, color: Colors.white);

  static getButtonStyle(Color backgroundColor) => ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      )),
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)));

  static getInputStyle(String label) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      hintText: label,
      labelText: label,
    );
  }

  static get boxDecorationCard => BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black87)],
        borderRadius: BorderRadius.circular(25),
      );
}
