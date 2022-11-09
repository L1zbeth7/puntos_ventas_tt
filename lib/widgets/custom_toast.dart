import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({
    Key? key,
    required this.mensaje,
    this.backgroundColor = Colors.black54,
    this.textColor = Colors.white,
  }) : super(key: key);

  final String mensaje;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Icon(Icons.check),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            mensaje,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }

  showToast(BuildContext context, {int? duration}) {
    FToast fToast = FToast();

    fToast.init(context);
    fToast.showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: backgroundColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Icon(Icons.check),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Text(
                  mensaje,
                  style: TextStyle(color: textColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(
          seconds: duration ?? 2,
        ));
  }
}
