import 'package:flash_list/models/group.dart';
import 'package:flash_list/providers/providers.dart';
import 'package:flash_list/widgets/group/group_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupsList extends HookConsumerWidget {
  const GroupsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.read(firestoreServiceProvider).groupsForUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final data = snapshot.data as List<Group>;
          final groups = data
              .map(
                (doc) => Group(
                  doc.title,
                  doc.createdAt,
                  doc.uid,
                  Color(doc.color!.value),
                  doc.body,
                  doc.permissions,
                ),
              )
              .toList();

          if (groups.isEmpty) {
            return const Center(child: Text('No lists yet...'));
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return GroupWrapper(group: group);
            },
          );
        }
      },
    );
  }
}
