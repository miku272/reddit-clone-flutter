import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../theme/pallete.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToAddPostTypeScreen(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currTheme = ref.watch(themeNotifierProvider);
    var cardHeightWidth = kIsWeb ? 360.0 : 120.0;
    var iconSize = kIsWeb ? 120.0 : 60.0;

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => navigateToAddPostTypeScreen(context, 'image'),
            child: SizedBox(
              height: cardHeightWidth,
              width: cardHeightWidth,
              child: Card(
                elevation: 16.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // ignore: deprecated_member_use
                color: currTheme.backgroundColor,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigateToAddPostTypeScreen(context, 'text'),
            child: SizedBox(
              height: cardHeightWidth,
              width: cardHeightWidth,
              child: Card(
                elevation: 16.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // ignore: deprecated_member_use
                color: currTheme.backgroundColor,
                child: Center(
                  child: Icon(
                    Icons.font_download_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => navigateToAddPostTypeScreen(context, 'link'),
            child: SizedBox(
              height: cardHeightWidth,
              width: cardHeightWidth,
              child: Card(
                elevation: 16.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // ignore: deprecated_member_use
                color: currTheme.backgroundColor,
                child: Center(
                  child: Icon(
                    Icons.link_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
