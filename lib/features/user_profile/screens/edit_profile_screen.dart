import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';

import '../../auth/controller/auth_controller.dart';
import '../controller/user_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  const EditProfileScreen({required this.uid, super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    final user = ref.read(userProvider);

    if (user != null) {
      nameController = TextEditingController(text: user.name);
    }
  }

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

  Future<void> save() async {
    await ref.read(userProfileControllerProvider.notifier).editProfile(
          context: context,
          profileFile: profileFile,
          bannerFile: bannerFile,
          name: nameController.text.trim(),
        );
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
          loading: () => const Loader(),
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          data: (user) {
            if (user == null) {
              return const Scaffold(
                body: Center(
                  child: Text('Something went wrong'),
                ),
              );
            }

            return isLoading
                ? const Loader()
                : Scaffold(
                    appBar: AppBar(
                      title: const Text('Edit profile'),
                      centerTitle: false,
                      actions: <Widget>[
                        TextButton(
                          onPressed: save,
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                    body: Padding(
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
                                          : user.banner.isEmpty ||
                                                  user.banner ==
                                                      Constants.bannerDefault
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 40,
                                                  ),
                                                )
                                              : Image.network(user.banner),
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
                                                NetworkImage(user.profilePic),
                                            radius: 30,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(18.0),
                              filled: true,
                              hintText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              border: InputBorder.none,
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
