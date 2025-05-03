import 'package:flutter/material.dart';
import 'package:library_app/screens/home/home.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontFamily: 'GI', fontWeight: FontWeight.w700),
          ),
          GestureDetector(
            child: Image.asset('assets/img/redbull.png', height: 50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const Home()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
