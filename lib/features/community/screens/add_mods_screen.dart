import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../controller/community_controller.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;

  const AddModsScreen({required this.name, super.key});

  @override
  ConsumerState<AddModsScreen> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  var ctr = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  Future<void> updateMods() async {
    await ref.read(communityControllerProvider.notifier).updateMods(
          context,
          widget.name,
          uids.toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: updateMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            loading: () => const Loader(),
            error: (error, stacktrace) => ErrorText(error: error.toString()),
            data: (community) {
              return ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (context, index) {
                  final member = community.members[index];

                  return ref.watch(getUserDataProvider(member)).when(
                        loading: () => const Loader(),
                        error: (error, stacktrace) => ErrorText(
                          error: error.toString(),
                        ),
                        data: (user) {
                          if (user == null) {
                            return const Text('User not found...');
                          }

                          if (community.mods.contains(member) &&
                              ctr <= community.mods.length) {
                            uids.add(member);
                          }

                          if (ctr <= community.mods.length) {
                            ctr++;
                          }

                          return CheckboxListTile(
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              if (value) {
                                addUid(member);
                              } else {
                                removeUid(member);
                              }
                            },
                            value: uids.contains(member),
                            title: Text(user.name),
                          );
                        },
                      );
                },
              );
            },
          ),
    );
  }
}
