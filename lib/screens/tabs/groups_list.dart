import 'package:flash_list/providers/group.dart';
import 'package:flash_list/widgets/group/group_wrapper.dart';
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
      return const Center(child: Text('No lists yet...'));
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
