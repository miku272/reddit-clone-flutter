import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';

import '../../../theme/pallete.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  Future<void> logOut(WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).logOut();
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
              onTap: () {},
              leading: const Icon(Icons.person),
              title: const Text('My profile'),
            ),
            ListTile(
              onTap: () => logOut(ref),
              leading: Icon(Icons.logout, color: Pallete.redColor),
              title: const Text('Logout'),
            ),
            Switch.adaptive(value: true, onChanged: (value) {}),
          ],
        ),
      ),
    );
  }
}
