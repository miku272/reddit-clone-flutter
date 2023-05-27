import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({required this.type, super.key});

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text('Share'),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
