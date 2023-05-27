import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

import '../../../theme/pallete.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  Future<void> logOut(WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(BuildContext context, String uid) async {
    Routemaster.of(context).push('/u/$uid');
  }

  Future<void> toggleTheme(WidgetRef ref) async {
    await ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic),
              radius: 70,
            ),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10.0),
            const Divider(color: Colors.black54),
            const SizedBox(height: 10.0),
            ListTile(
              onTap: () => navigateToUserProfile(context, user.uid),
              leading: const Icon(Icons.person),
              title: const Text('My profile'),
            ),
            ListTile(
              onTap: () => logOut(ref),
              leading: Icon(Icons.logout, color: Pallete.redColor),
              title: const Text('Logout'),
            ),
            Switch.adaptive(
                value: ref.watch(themeNotifierProvider.notifier).mode ==
                        ThemeMode.dark
                    ? true
                    : false,
                onChanged: (value) async {
                  toggleTheme(ref);
                }),
          ],
        ),
      ),
    );
  }
}
