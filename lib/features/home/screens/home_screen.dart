import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/pallete.dart';

import '../../../core/constants/constants.dart';

import '../../auth/controller/auth_controller.dart';

import '../../../models/user_model.dart';

import '../drawers/community_list_drawer.dart';
import '../drawers/profile_drawer.dart';

import '../delegates/search_community_delegate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _page = 0;

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    final currTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
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
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => displayEndDrawer(context),
              icon: CircleAvatar(
                backgroundImage:
                    user != null ? NetworkImage(user.profilePic) : null,
              ),
            );
          }),
        ],
      ),
      body: Constants.tabWidgets[_page],
      bottomNavigationBar: CupertinoTabBar(
        onTap: onPageChange,
        currentIndex: _page,
        activeColor: currTheme.iconTheme.color,
        // ignore: deprecated_member_use
        backgroundColor: currTheme.backgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
        ],
      ),
    );
  }
}
