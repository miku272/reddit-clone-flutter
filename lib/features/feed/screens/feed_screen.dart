import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/post_card.dart';

import '../../auth/controller/auth_controller.dart';
import '../../community/controller/community_controller.dart';
import '../../post/controllers/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !(user.isAuthenticated);

    if (isGuest) {
      return ref.watch(userCommunityProvider).when(
          loading: () => const Loader(),
          error: (error, stacktrace) => ErrorText(error: error.toString()),
          data: (communities) {
            return ref.watch(guestPostStream).when(
                loading: () => const Loader(),
                error: (error, stacktrace) =>
                    ErrorText(error: error.toString()),
                data: (posts) {
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: posts[index]);
                    },
                  );
                });
          });
    } else {
      return ref.watch(userCommunityProvider).when(
          loading: () => const Loader(),
          error: (error, stacktrace) => ErrorText(error: error.toString()),
          data: (communities) {
            return ref.watch(userPostsStream(communities)).when(
                loading: () => const Loader(),
                error: (error, stacktrace) =>
                    ErrorText(error: error.toString()),
                data: (posts) {
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: posts[index]);
                    },
                  );
                });
          });
    }
  }
}
