import 'package:flashlist/models/group.dart';
import 'package:flashlist/providers/group/group.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/async_value_widget.dart';
import 'package:flashlist/widgets/group/group_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupsList extends HookConsumerWidget {
  const GroupsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(userGroupsProvider);
    final listKey = GlobalKey<AnimatedListState>();

    return AsyncValueWidget<List<Group>>(
      value: groups,
      data: (data) {
        if (data.isEmpty) {
          return Center(
            child: Text(
              appLocalizationsOf(context).noListsYet,
            ),
          );
        } else {
          return AnimatedList(
            key: listKey,
            initialItemCount: data.length,
            itemBuilder: (context, index, animation) {
              final group = data[index];
              return GroupWrapper(group: group);
            },
          );
        }
      },
    );
  }
}
