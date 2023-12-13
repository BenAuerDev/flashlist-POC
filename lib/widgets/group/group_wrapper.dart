import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/models/group.dart';
import 'package:flashlist/routing/app_router.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/avatar_group.dart';
import 'package:flashlist/widgets/group/group_body.dart';
import 'package:flashlist/widgets/group/group_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupWrapper extends StatelessWidget {
  const GroupWrapper({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    void addItemToBody() => context.goNamed(
          AppRoute.addItemToBody.name,
          pathParameters: {'id': group.uid},
        );

    return Container(
      margin: const EdgeInsets.all(Sizes.p4),
      padding:
          const EdgeInsets.symmetric(horizontal: Sizes.p4, vertical: Sizes.p8),
      decoration: BoxDecoration(
        border: Border.all(color: group.color!),
        borderRadius: BorderRadius.circular(Sizes.p8),
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
                        color: colorSchemeOf(context).onBackground,
                        fontSize: Sizes.p24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvatarGroup(group: group),
                      GroupMenu(group: group),
                    ],
                  ),
                ),
              ],
            ),
          ),
          gapH8,
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
