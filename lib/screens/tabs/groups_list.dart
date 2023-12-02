import 'package:flashlist/providers/group.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/group/group_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupsList extends HookConsumerWidget {
  const GroupsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(userGroupsProvider);

    if (groups.value == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (groups.value!.isEmpty) {
      return Center(child: Text(appLocalizationsOf(context).noListsYet));
    }

    if (groups.hasError) {
      return Text('Error: ${groups.error}');
    }

    return ListView.builder(
      itemCount: groups.value!.length,
      itemBuilder: (context, index) {
        final group = groups.value![index];
        return GroupWrapper(group: group);
      },
    );
  }
}
