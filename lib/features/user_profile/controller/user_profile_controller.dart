import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/user_profile_repository.dart';

import '../../auth/controller/auth_controller.dart';

import '../../../models/user_model.dart';

import '../../../core/utils.dart';
import '../../../core/providers/storage_repository_provider.dart';

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
    required File? bannerFile,
    required String name,
  }) async {
    state = true;

    UserModel? user = _ref.read(userProvider);

    if (user == null) {
      return;
    }

    if (profileFile != null) {
      final result = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
      );

      result.fold(
        (l) => showSnackbar(context, l.message),
        (r) => user = user!.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null) {
      final result = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user!.uid,
        file: bannerFile,
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
}
