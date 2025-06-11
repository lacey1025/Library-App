import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/invite/invite.dart';
import 'package:library_app/screens/login/login_screen.dart';
import 'package:library_app/screens/link_library/fix_errors_page.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionProvider);

    return Drawer(
      backgroundColor: Colors.grey[800],
      child: sessionAsync.when(
        loading: () => const SizedBox.shrink(), // nothing is shown
        error:
            (e, st) => ListView(
              children: const [
                DrawerHeader(
                  child: Text(
                    'Error loading session',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
        data: (session) {
          final hasErrors = session?.hasSheetErrors ?? false;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                padding: const EdgeInsets.fromLTRB(18, 30, 18, 18),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 139, 32, 32),
                ),
                child: Text(
                  'Menu',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 28),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_add, color: Colors.white),
                title: Text(
                  'Invite User',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const InviteScreen()),
                  );
                },
              ),
              if (hasErrors)
                ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: Text(
                    'Fix Google Sheet Errors',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FixErrorsPage()),
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onTap: () async {
                  final navigator = Navigator.of(context);
                  await ref.read(sessionProvider.notifier).logout();
                  await ref.read(googleSignInProvider).signOut();
                  navigator.pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
