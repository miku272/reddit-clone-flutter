import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../core/utils.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';

import '../../../models/community_model.dart';

import '../../../responsive/responsive.dart';

import '../../community/controller/community_controller.dart';
import '../controllers/post_controller.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({required this.type, super.key});

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  Uint8List? bannerWebFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  Future<void> selectBannerImage() async {
    final result = await pickImage();

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = result.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(result.files.first.path!);
        });
      }
    }
  }

  Future<void> sharePost() async {
    if (widget.type == 'image' &&
        (bannerFile != null || bannerWebFile != null) &&
        titleController.text.isNotEmpty) {
      await ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
            webFile: bannerWebFile,
          );
    } else if (widget.type == 'text' &&
        descriptionController.text.isNotEmpty &&
        titleController.text.isNotEmpty) {
      await ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        linkController.text.isNotEmpty &&
        titleController.text.isNotEmpty) {
      await ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackbar(context, 'Please enter all the fields');
    }
  }

  @override
  void dispose() {
    super.dispose();

    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      maxLength: 30,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        filled: true,
                        hintText: 'Enter title here',
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    if (isTypeImage)
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
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: bannerWebFile != null
                                ? Image.memory(bannerWebFile!)
                                : bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : const Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    if (isTypeText)
                      TextField(
                        controller: descriptionController,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(18.0),
                          filled: true,
                          hintText: 'Enter description here',
                          border: InputBorder.none,
                        ),
                      ),
                    if (isTypeLink)
                      TextField(
                        controller: linkController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(18.0),
                          filled: true,
                          hintText: 'Enter link here',
                          border: InputBorder.none,
                        ),
                      ),
                    const SizedBox(height: 20.0),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Select community'),
                    ),
                    ref.watch(userCommunityProvider).when(
                        loading: () => const Loader(),
                        error: (error, stacktrace) => ErrorText(
                              error: error.toString(),
                            ),
                        data: (userCommunities) {
                          communities = userCommunities;

                          if (userCommunities.isEmpty) {
                            return const SizedBox();
                          }

                          return DropdownButton(
                            value: selectedCommunity ?? userCommunities[0],
                            onChanged: (value) {
                              setState(() {
                                selectedCommunity = value;
                              });
                            },
                            onTap: () {},
                            items: userCommunities
                                .map(
                                  (userCommunity) => DropdownMenuItem(
                                    value: userCommunity,
                                    child: Text(userCommunity.name),
                                  ),
                                )
                                .toList(),
                          );
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}
