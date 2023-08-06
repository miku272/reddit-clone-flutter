import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils.dart';
import '../../../core/providers/storage_repository_provider.dart';

import '../../../models/user_model.dart';
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';
import '../../../models/comment_model.dart';

import '../../auth/controller/auth_controller.dart';
import '../repository/post_repository.dart';

import '../../user_profile/controller/user_profile_controller.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);

  return PostController(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userPostsStream =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.read(postControllerProvider.notifier);

  return postController.fetchUserPosts(communities);
});

final guestPostStream = StreamProvider(
  (ref) => ref.read(postControllerProvider.notifier).fetchGuestPosts(),
);

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.read(postControllerProvider.notifier);

  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.read(postControllerProvider.notifier);

  return postController.getPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Future<void> shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;

    String postId = const Uuid().v4();
    UserModel user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      userId: user.uid,
      userName: user.name,
      communityProfilePic: selectedCommunity.avatar,
      communityName: selectedCommunity.name,
      title: title,
      description: description,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      postType: 'text',
      createdAt: DateTime.now(),
      awards: [],
    );

    final res = await _postRepository.addPost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
          UserKarma.textPost,
        );

    state = false;

    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Post uploaded succesfully');
      Routemaster.of(context).pop();
    });
  }

  Future<void> shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;

    String postId = const Uuid().v4();
    UserModel user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      userId: user.uid,
      userName: user.name,
      communityProfilePic: selectedCommunity.avatar,
      communityName: selectedCommunity.name,
      title: title,
      link: link,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      postType: 'link',
      createdAt: DateTime.now(),
      awards: [],
    );

    final res = await _postRepository.addPost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
          UserKarma.linkPost,
        );

    state = false;

    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Post uploaded succesfully');
      Routemaster.of(context).pop();
    });
  }

  Future<void> shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;

    String postId = const Uuid().v4();
    UserModel user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: '/posts/${selectedCommunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold((l) => showSnackbar(context, l.message), (r) async {
      final Post post = Post(
        id: postId,
        userId: user.uid,
        userName: user.name,
        communityProfilePic: selectedCommunity.avatar,
        communityName: selectedCommunity.name,
        title: title,
        link: r,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        postType: 'image',
        createdAt: DateTime.now(),
        awards: [],
      );

      final res = await _postRepository.addPost(post);
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
            UserKarma.imagePost,
          );

      state = false;

      res.fold((l) => showSnackbar(context, l.message), (r) {
        showSnackbar(context, 'Post uploaded succesfully');
        Routemaster.of(context).pop();
      });
    });
  }

  Future<void> deletePost(BuildContext context, Post post) async {
    final res = await _postRepository.deletePost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
          UserKarma.deletePost,
        );

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => showSnackbar(context, 'Post deleted succesfully'),
    );
  }

  Future<void> upvote(Post post) async {
    final userId = _ref.read(userProvider)!.uid;

    await _postRepository.upvote(post, userId);
  }

  Future<void> downvote(Post post) async {
    final userId = _ref.read(userProvider)!.uid;

    await _postRepository.downvote(post, userId);
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }

    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  Future<void> addComment({
    required BuildContext context,
    required String commentText,
    required String postId,
  }) async {
    final user = _ref.read(userProvider)!;
    final commentId = const Uuid().v4();

    Comment comment = Comment(
      commentId: commentId,
      postId: postId,
      text: commentText,
      createdAt: DateTime.now(),
      userId: user.uid,
      userName: user.name,
      userProfilePic: user.profilePic,
    );

    final res = await _postRepository.addComment(comment);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
          UserKarma.comment,
        );

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => null,
    );
  }

  Future<void> awardPost({
    required BuildContext context,
    required String award,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(post, award, user.uid);

    res.fold((l) => showSnackbar(context, l.message), (r) {
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
            UserKarma.awardPost,
          );
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);

        return state;
      });

      Routemaster.of(context).pop();
    });
  }

  Stream<List<Comment>> getPostComments(String postId) {
    return _postRepository.getPostComments(postId);
  }
}
