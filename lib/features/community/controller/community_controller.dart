import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/failure.dart';

import '../repository/community_repository.dart';

import '../../../models/community_model.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';

import '../../auth/controller/auth_controller.dart';

final userCommunityProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);

  return communityController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>(
  (ref) {
    final communityRepository = ref.watch(communityRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);

    return CommunityController(
      communityRepository: communityRepository,
      storageRepository: storageRepository,
      ref: ref,
    );
  },
);

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communityController = ref.watch(communityControllerProvider.notifier);

  return communityController.getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  final communityController = ref.watch(communityControllerProvider.notifier);

  return communityController.searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  Future<void> createCommunity(String name, BuildContext context) async {
    state = true;

    String? uid = _ref.read(userProvider)?.uid;

    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid!],
      mods: [uid],
    );

    final result = await _communityRepository.createCommunity(community);
    state = false;

    result.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        showSnackbar(context, 'Community created successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  Future<void> joinOrLeaveCommunity(
      Community community, BuildContext context) async {
    final user = _ref.read(userProvider);

    Either<Failure, void> res;

    if (user != null) {
      if (community.members.contains(user.uid)) {
        res = await _communityRepository.leaveCommunity(
          community.name,
          user.uid,
        );
      } else {
        res = await _communityRepository.joinCommunity(
          community.name,
          user.uid,
        );
      }

      res.fold((l) => showSnackbar(context, l.message), (r) {
        if (community.members.contains(user.uid)) {
          showSnackbar(context, 'Community left');
        } else {
          showSnackbar(context, 'Community joined!');
        }
      });
    }
  }

  Future<void> leaveCommunity() async {}

  Future<void> editCommunity({
    required BuildContext context,
    required Community community,
    required File? profileFile,
    required File? bannerFile,
  }) async {
    state = true;

    if (profileFile != null) {
      final result = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );

      result.fold(
        (l) => showSnackbar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      final result = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );

      result.fold(
        (l) => showSnackbar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final result = await _communityRepository.editCommunity(community);

    result.fold(
      (l) => showSnackbar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );

    state = false;
  }

  Stream<List<Community>> getUserCommunities() {
    String uid = _ref.read(userProvider)!.uid;

    return _communityRepository.getUserCommunity(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }
}
