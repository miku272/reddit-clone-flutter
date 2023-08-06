import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:any_link_preview/any_link_preview.dart';

import '../../responsive/responsive.dart';

import './loader.dart';
import 'error_text.dart';
import '../constants/constants.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../../features/community/controller/community_controller.dart';
import '../../features/post/controllers/post_controller.dart';

import '../../theme/pallete.dart';

import '../../models/post_model.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({required this.post, super.key});

  Future<void> deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  Future<void> upvote(WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).upvote(post);
  }

  Future<void> downvote(WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).downvote(post);
  }

  Future<void> awardPost(
      WidgetRef ref, BuildContext context, String award) async {
    await ref.read(postControllerProvider.notifier).awardPost(
          context: context,
          award: award,
          post: post,
        );
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/${post.userId}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.postType == 'image';
    final isTypeText = post.postType == 'text';
    final isTypeLink = post.postType == 'link';

    final user = ref.watch(userProvider)!;
    final isGuest = !(user.isAuthenticated);
    final currentTheme = ref.watch(themeNotifierProvider);

    return Responsive(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 16.0,
                        ).copyWith(right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          post.communityProfilePic,
                                        ),
                                        radius: 16.0,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToCommunity(context),
                                            child: Text(
                                              'r/${post.communityName}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToUserProfile(context),
                                            child: Text(
                                              'u/${post.userName}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.userId == user.uid)
                                  IconButton(
                                    onPressed: () async {
                                      await deletePost(ref, context);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Pallete.redColor,
                                    ),
                                  ),
                              ],
                            ),
                            if (post.awards.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  itemCount: post.awards.length,
                                  itemBuilder: (context, index) {
                                    return Image.asset(
                                      Constants.awards[post.awards[index]]!,
                                      height: 23,
                                    );
                                  },
                                ),
                              ),
                            ],
                            const SizedBox(height: 10.0),
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            if (isTypeImage)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: double.infinity,
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: AnyLinkPreview(
                                  link: post.link!,
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                ),
                              ),
                            if (isTypeText)
                              Text(
                                post.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed:
                                          isGuest ? null : () => upvote(ref),
                                      icon: Icon(
                                        Constants.up,
                                        color: post.upvotes.contains(user.uid)
                                            ? Pallete.redColor
                                            : null,
                                      ),
                                    ),
                                    Text(
                                      '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed:
                                          isGuest ? null : () => downvote(ref),
                                      icon: Icon(
                                        Constants.down,
                                        color: post.downvotes.contains(user.uid)
                                            ? Pallete.blueColor
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () =>
                                          navigateToComments(context),
                                      icon: const Icon(Icons.comment),
                                    ),
                                    GestureDetector(
                                      onTap: () => navigateToComments(context),
                                      child: Text(
                                        '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ref
                                    .watch(
                                      getCommunityByNameProvider(
                                        post.communityName,
                                      ),
                                    )
                                    .when(
                                      loading: () => const Loader(),
                                      error: (error, stacktrace) => ErrorText(
                                        error: error.toString(),
                                      ),
                                      data: (community) {
                                        if (community.mods.contains(user.uid)) {
                                          return IconButton(
                                            onPressed: () => deletePost(
                                              ref,
                                              context,
                                            ),
                                            icon: const Icon(
                                              Icons.admin_panel_settings,
                                            ),
                                          );
                                        }

                                        return const SizedBox();
                                      },
                                    ),
                                if (post.userId != user.uid)
                                  IconButton(
                                    onPressed: isGuest
                                        ? null
                                        : () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                    ),
                                                    itemCount:
                                                        user.awards.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final award =
                                                          user.awards[index];

                                                      return GestureDetector(
                                                        onTap: () => awardPost(
                                                          ref,
                                                          context,
                                                          award,
                                                        ),
                                                        child: Image.asset(
                                                          Constants
                                                              .awards[award]!,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                    icon: const Icon(
                                        Icons.card_giftcard_outlined),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
