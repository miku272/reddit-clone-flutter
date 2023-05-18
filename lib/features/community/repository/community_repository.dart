import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';

import '../../../models/community_model.dart';

final communityRepositoryProvider = Provider(
  (ref) => CommunityRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _communities => _firestore.collection(
        FirebaseConstants.communitiesCollection,
      );

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();

      if (communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }

  Stream<List<Community>> getUserCommunity(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Community> communities = [];

      for (var doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }

      return communities;
    });
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(
        _communities.doc(community.name).update(community.toMap()),
      );
    } on FirebaseException catch (error) {
      throw error.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }
}
