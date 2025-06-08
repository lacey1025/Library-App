import 'package:flutter/material.dart';
import 'package:library_app/screens/home/home.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      centerTitle: true,
      title: Text(
        title,
        // style: TextStyle(
        //   fontFamily: 'GI',
        //   fontWeight: FontWeight.w700,
        // ),
      ),
      actions: [
        IconButton(
          icon: Image.asset('assets/img/redbull.png', height: 60),
          padding: EdgeInsets.only(bottom: 10),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => const Home()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
