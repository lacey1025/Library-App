import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final Icon icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(75, 75, 75, 1),
              Color.fromRGBO(55, 55, 55, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: height * 0.2,
        margin: const EdgeInsets.all(10),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            elevation: 3,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'GI',
                  fontWeight: FontWeight.w700,
                ),
              ),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
