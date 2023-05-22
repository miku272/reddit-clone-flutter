import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;

  const ModToolsScreen({required this.name, super.key});

  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod tools'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            onTap: () => navigateToAddMods(context),
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add moderators'),
          ),
          ListTile(
            onTap: () => navigateToEditCommunity(context),
            leading: const Icon(Icons.edit),
            title: const Text('Edit community'),
          ),
        ],
      ),
    );
  }
}
