import 'package:flutter/material.dart';
import 'package:library_app/screens/invite/invite.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[800],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.fromLTRB(18, 30, 18, 18),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 139, 32, 32),
            ),
            child: Text(
              'Menu',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 28),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_add, color: Colors.white),
            title: Text(
              'Invite User',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const InviteScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
