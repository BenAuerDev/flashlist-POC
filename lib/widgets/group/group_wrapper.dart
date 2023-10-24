import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/screens/new_body_item_form.dart';
import 'package:brainstorm_array/widgets/avatar_group.dart';
import 'package:brainstorm_array/widgets/group/group_body.dart';
import 'package:brainstorm_array/widgets/group/group_menu.dart';
import 'package:flutter/material.dart';

class GroupWrapper extends StatelessWidget {
  const GroupWrapper({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    void addItemToBody() async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NewBodyItemForm(group: group),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: group.color!),
        color: group.color!.withOpacity(0.2),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 38,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Center(
                  child: Hero(
                    tag: '${group.uid}-${group.title}',
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvatarGroup(group: group),
                    GroupMenu(group: group),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Hero(
            tag: '${group.uid}-${group.body.length}',
            child: GroupBody(
              group: group,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: addItemToBody,
                icon: const Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}
