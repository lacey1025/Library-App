import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? colorStart;
  final Color? colorEnd;
  final double? height;
  final double? width;
  final Widget text;
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.colorStart,
    this.colorEnd,
    this.height,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (colorStart != null) ? colorStart! : Color.fromRGBO(185, 0, 0, 1),
              (colorEnd != null) ? colorEnd! : Color.fromRGBO(100, 0, 0, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          height: (height != null) ? height : null,
          width: (width != null) ? width : null,
          alignment: Alignment.center,
          child:
              (icon != null)
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [icon!, const SizedBox(width: 8), text],
                  )
                  : text,
        ),
      ),
    );
  }
}
