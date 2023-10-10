import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/widgets/array_widget.dart';
import 'package:brainstorm_array/widgets/group/group_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GroupWidget extends HookWidget {
  const GroupWidget({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                Text(
                  group.title,
                  style: TextStyle(
                    color: group.color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GroupMenu(group: group),
              ],
            ),
            const SizedBox(height: 12),
            ArrayWidget(groupUid: group.uid),
          ],
        ),
      ),
    );
  }
}
