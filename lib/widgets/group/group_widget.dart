import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/widgets/avatar_group.dart';
import 'package:brainstorm_array/widgets/group/group_body.dart';
import 'package:brainstorm_array/widgets/group/group_menu.dart';
import 'package:flutter/material.dart';

class GroupWidget extends StatelessWidget {
  const GroupWidget({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 38,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Center(
                    child: Text(
                      group.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: group.color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (group.permissions['editors'].isEmpty)
                        const SizedBox(width: 50),
                      if (group.permissions['editors'].isNotEmpty)
                        AvatarGroup(group: group),
                      GroupMenu(group: group),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GroupBody(group: group),
          ],
        ),
      ),
    );
  }
}
