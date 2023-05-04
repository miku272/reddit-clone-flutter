import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../community/controller/community_controller.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, String name) {
    Routemaster.of(context).push('/r/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () => navigateToCreateCommunity(context),
              leading: const Icon(Icons.add),
              title: const Text('Create a community'),
            ),
            ref.watch(userCommunityProvider).when(
                  data: (communities) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];

                        return ListTile(
                          onTap: () => navigateToCommunity(
                            context,
                            community.name,
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text('r/${community.name}'),
                        );
                      },
                    );
                  },
                  error: (error, stacktrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          ],
        ),
      ),
    );
  }
}
