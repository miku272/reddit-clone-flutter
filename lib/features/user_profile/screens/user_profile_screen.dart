import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/post_card.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;

  const UserProfileScreen({required this.uid, super.key});

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) {
              if (user == null) {
                return const Center(
                  child: Text('User not found...'),
                );
              }

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 250,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Image.network(
                              user.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20.0).copyWith(
                              bottom: 70.0,
                            ),
                            alignment: Alignment.bottomLeft,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: NetworkImage(user.profilePic),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            alignment: Alignment.bottomLeft,
                            child: OutlinedButton(
                              onPressed: () => navigateToEditUser(context),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0,
                                ),
                              ),
                              child: const Text('Edit profile'),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'u/${user.name}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                '${user.karma} karma',
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            const Divider(thickness: 2),
                            // const SizedBox(height: 5.0),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: ref.watch(getUserPostsProvider(uid)).when(
                      loading: () => const Loader(),
                      error: (error, stacktrace) => ErrorText(
                        error: error.toString(),
                      ),
                      data: (posts) {
                        return ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return PostCard(post: posts[index]);
                            });
                      },
                    ),
              );
            },
            error: (error, stacktrace) => ErrorText(error: error.toString()),
            // error: (error, stacktrace) {
            //           print(error);
            //   return null;
            // },
            loading: () => const Loader(),
          ),
    );
  }
}
