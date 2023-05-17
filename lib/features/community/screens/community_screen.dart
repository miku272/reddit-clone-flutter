import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../controller/community_controller.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';

import '../../auth/controller/auth_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({
    required this.name,
    super.key,
  });

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? uid = ref.watch(userProvider)?.uid;

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Image.network(
                              community.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'r/${community.name}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: community.mods.contains(uid)
                                      ? () => navigateToModTools(context)
                                      : () {
                                          debugPrint('Not a member');
                                        },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    community.mods.contains(uid)
                                        ? 'Mod tools'
                                        : community.members.contains(uid)
                                            ? 'Joined'
                                            : 'Join',
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                '${community.members.length} members',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(),
              );
            },
            error: (error, stacktrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
