import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/constants.dart';

import '../../../core/common/sign_in_button.dart';
import '../../../core/common/loader.dart';

import '../controller/auth_controller.dart';

import '../../../responsive/responsive.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> signInAsGuest(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 40,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => signInAsGuest(context, ref),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: <Widget>[
                const SizedBox(height: 30),
                const Text(
                  'Dive into anything',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Constants.loginEmotePath,
                    height: 400,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Responsive(child: SignInButton()),
                ),
              ],
            ),
    );
  }
}
