import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:any_link_preview/any_link_preview.dart';

import '../../theme/pallete.dart';

import '../../models/post_model.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({required this.post, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.postType == 'image';
    final isTypeText = post.postType == 'text';
    final isTypeLink = post.postType == 'link';

    final currentTheme = ref.watch(themeNotifierProvider);

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 16.0,
                      ).copyWith(right: 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  post.communityProfilePic,
                                ),
                                radius: 16.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
