import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../core/constants/constants.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';
import '../../../core/utils.dart';

import '../../../models/community_model.dart';

import '../controller/community_controller.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;

  const EditCommunityScreen({required this.name, super.key});

  @override
  ConsumerState<EditCommunityScreen> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  Future<void> selectBannerImage() async {
    final result = await pickImage();

    if (result != null) {
      setState(() {
        bannerFile = File(result.files.first.path!);
      });
    }
  }

  Future<void> selectProfileImage() async {
    final result = await pickImage();

    if (result != null) {
      setState(() {
        profileFile = File(result.files.first.path!);
      });
    }
  }

  Future<void> save(Community community) async {
    await ref.read(communityControllerProvider.notifier).editCommunity(
          context: context,
          community: community,
          profileFile: profileFile,
          bannerFile: bannerFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          loading: () => const Loader(),
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          data: (community) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit community'),
                centerTitle: false,
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      await save(community);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 200,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: selectBannerImage,
                                  child: DottedBorder(
                                    color: Colors.white,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10.0),
                                    dashPattern: const [10, 4],
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: bannerFile != null
                                          ? Image.file(bannerFile!)
                                          : community.banner.isEmpty ||
                                                  community.banner ==
                                                      Constants.bannerDefault
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 40,
                                                  ),
                                                )
                                              : Image.network(community.banner),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: profileFile != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                FileImage(profileFile!),
                                            radius: 30,
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(community.avatar),
                                            radius: 30,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        );
  }
}
