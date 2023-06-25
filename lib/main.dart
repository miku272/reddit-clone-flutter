import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './firebase_options.dart';

import './theme/pallete.dart';

import './router.dart';

import './core/common/error_text.dart';
import './core/common/loader.dart';

import './models/user_model.dart';

import './features/auth/controller/auth_controller.dart';

// import './temp_animation_1.dart';
import './temp_animation_2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return ref.watch(authStateChangeProvider).when(
    //       data: (data) => MaterialApp.router(
    //         title: 'Reddit Clone',
    //         debugShowCheckedModeBanner: false,
    //         // theme: Pallete.darkModeAppTheme,
    //         theme: ref.watch(themeNotifierProvider),
    //         // home: const LoginScreen(),
    //         routerDelegate: RoutemasterDelegate(
    //           routesBuilder: (context) {
    //             if (data != null) {
    //               getData(ref, data);

    //               if (userModel != null) {
    //                 return loggedInRoute;
    //               }
    //             }
    //             return loggedOutRoute;
    //           },
    //         ),
    //         routeInformationParser: const RoutemasterParser(),
    //       ),
    //       error: (error, stackTrace) => ErrorText(error: error.toString()),
    //       loading: () => const Loader(),
    //     );
    return const MaterialApp(
      title: 'FLutter animation',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: TempAnimation2(),
    );
  }
}
