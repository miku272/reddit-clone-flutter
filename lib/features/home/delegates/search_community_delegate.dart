import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../community/controller/community_controller.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/error_text.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef _ref;

  SearchCommunityDelegate({required WidgetRef ref}) : _ref = ref;

  @override
  List<Widget>? buildActions(BuildContext context) {
    // throw UnimplementedError();

    return <Widget>[
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.close,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // throw UnimplementedError();

    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // throw UnimplementedError();

    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // throw UnimplementedError();

    void navigateToCommunity(BuildContext context, String name) {
      Routemaster.of(context).push('/r/$name');
    }

    return _ref.watch(searchCommunityProvider(query)).when(
          loading: () => const Loader(),
          error: (error, stacktrace) => ErrorText(error: error.toString()),
          data: (communities) {
            return ListView.builder(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];

                return ListTile(
                  onTap: () => navigateToCommunity(context, community.name),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(community.avatar),
                  ),
                  title: Text('r/${community.name}'),
                );
              },
            );
          },
        );
  }
}
