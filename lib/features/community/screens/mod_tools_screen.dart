import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod tools'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add moderators'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.edit),
            title: const Text('Edit community'),
          ),
        ],
      ),
    );
  }
}
