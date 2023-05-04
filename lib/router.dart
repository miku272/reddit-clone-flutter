import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import './features/auth/screens/login_screen.dart';

import './features/home/screens/home_screen.dart';

import './features/community/screens/create_community.dart';
import './features/community/screens/community_screen.dart';
import './features/community/screens/mod_tools_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (routeData) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (routeData) => const MaterialPage(child: HomeScreen()),
  '/create-community': (routeData) => const MaterialPage(
        child: CreateCommunityScreen(),
      ),
  '/r/:name': (routeData) => MaterialPage(
        child: CommunityScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/mod-tools': (routeData) => const MaterialPage(
        child: ModToolsScreen(),
      ),
});
