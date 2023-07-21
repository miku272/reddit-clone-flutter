import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/post_card.dart';

import '../../../models/post_model.dart';

import '../widgets/comment_card.dart';

import '../controllers/post_controller.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;

  const CommentScreen({required this.postId, super.key});

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final _commentController = TextEditingController();

  Future<void> addComment(Post post) async {
    await ref.read(postControllerProvider.notifier).addComment(
          context: context,
          commentText: _commentController.text.trim(),
          postId: post.id,
        );

    setState(() {
      _commentController.text = '';
    });
  }

  @override
  void dispose() {
    super.dispose();

    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            loading: () => const Loader(),
            error: (error, stacktrace) => ErrorText(error: error.toString()),
            data: (post) {
              return Column(
                children: <Widget>[
                  PostCard(post: post),
                  const SizedBox(height: 10.0),
                  TextField(
                    onSubmitted: (value) {
                      if (value.trim() == '') {
                        return;
                      }

                      addComment(post);
                    },
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'What are your thoughts?',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ref.watch(getPostCommentsProvider(post.id)).when(
                        loading: () => const Loader(),
                        error: (error, stacktrace) => ErrorText(
                          error: error.toString(),
                        ),
                        data: (comments) {
                          if (comments.isEmpty) {
                            return const Center(
                              child: Text('No comments...'),
                            );
                          }

                          return SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return CommentCard(comment: comments[index]);
                              },
                            ),
                          );
                        },
                      ),
                ],
              );
            },
          ),
    );
  }
}
