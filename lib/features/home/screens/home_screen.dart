import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';

import '../../../models/user_model.dart';

import '../drawers/community_list_drawer.dart';

import '../delegates/search_community_delegate.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel? user = ref.watch(userProvider);

    return Scaffold(
      drawer: const CommunityListDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchCommunityDelegate(ref: ref),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage:
                  user != null ? NetworkImage(user.profilePic) : null,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          user == null ? 'Empty' : user.name,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
