import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/user_profile_repository.dart';

import '../../auth/controller/auth_controller.dart';

import '../../../models/user_model.dart';
import '../../../models/post_model.dart';

import '../../../core/utils.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/enums/enums.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
  (ref) {
    final userProfileRepository = ref.watch(userProfileRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);

    return UserProfileController(
      userProfileRepository: userProfileRepository,
      storageRepository: storageRepository,
      ref: ref,
    );
  },
);

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);

  return userProfileController.getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Future<void> editProfile({
    required BuildContext context,
    required File? profileFile,
    required Uint8List? profileWebFile,
    required File? bannerFile,
    required Uint8List? bannerWebFile,
    required String name,
  }) async {
    state = true;

    UserModel? user = _ref.read(userProvider);

    if (user == null) {
      return;
    }

    if (profileFile != null || profileWebFile != null) {
      final result = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
        webFile: profileWebFile,
      );

      result.fold(
        (l) => showSnackbar(context, l.message),
        (r) => user = user!.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null || bannerWebFile != null) {
      final result = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user!.uid,
        file: bannerFile,
        webFile: bannerWebFile,
      );

      result.fold(
        (l) => showSnackbar(context, l.message),
        (r) => user = user!.copyWith(banner: r),
      );
    }

    user = user!.copyWith(name: name);

    final result = await _userProfileRepository.editProfile(user!);

    result.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);

        Routemaster.of(context).pop();
      },
    );

    state = false;
  }

  Future<void> updateUserKarma(UserKarma userKarma) async {
    UserModel user = _ref.read(userProvider)!;

    user = user.copyWith(karma: user.karma + userKarma.karma);

    final res = await _userProfileRepository.updateUserKarma(user);

    res.fold(
      (l) => null,
      (r) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPost(uid);
  }
}
