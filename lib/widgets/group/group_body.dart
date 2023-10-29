import 'dart:ui';

import 'package:flash_list/models/group.dart';
import 'package:flash_list/providers/group.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupBody extends ConsumerStatefulWidget {
  const GroupBody({super.key, required this.group});

  final Group group;

  @override
  ConsumerState<GroupBody> createState() {
    return _DragAndDropListState();
  }
}

class _DragAndDropListState extends ConsumerState<GroupBody> {
  @override
  Widget build(BuildContext context) {
    var items = ref.watch(groupBodyProvider(widget.group.uid)).value;

    void showSnackbar(String message, SnackBarAction? action) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: action,
          content: Text(message),
          backgroundColor: retrieveColorScheme(context).primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    void reinsertItemIntoDb(List<dynamic> oldState) async {
      ref.read(
        setGroupBodyProvider(
          {
            'groupUid': widget.group.uid,
            'body': oldState,
          },
        ),
      );
    }

    void onDismissItem(item) async {
      final oldState = items!.toList();
      final index = items.indexOf(item);

      setState(() {
        items.remove(item);
      });

      final response = ref.read(
        removeItemFromGroupBodyProvider(
          {
            'groupUid': widget.group.uid,
            'itemUid': item['uid'],
          },
        ),
      );

      if (!response.hasError) {
        showSnackbar(
          'Item removed',
          SnackBarAction(
            label: 'Undo',
            onPressed: () {
              reinsertItemIntoDb(oldState);
              items.insert(index, item);
            },
          ),
        );
      } else {
        showSnackbar('Error removing item please try again', null);
      }
    }

    final List<ReorderableDelayedDragStartListener> bodyItems =
        <ReorderableDelayedDragStartListener>[
      if (items != null && items.isNotEmpty)
        for (int index = 0; index < items.length; index += 1)
          ReorderableDelayedDragStartListener(
            index: index,
            key: Key('$index'),
            child: Dismissible(
              key: ValueKey(items[index]['uid']),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                onDismissItem(items[index]);
              },
              background: Container(
                decoration: BoxDecoration(
                  color: retrieveColorScheme(context).error.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  vertical:
                      retrieveTheme(context).cardTheme.margin!.vertical / 2,
                ),
              ),
              child: Card(
                child: Container(
                  width: double.infinity,
                  height: 40,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${items[index]['name']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
    ];

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(1, 6, animValue)!;
          final double scale = lerpDouble(1, 1.02, animValue)!;
          return Transform.scale(
            scale: scale,
            child: Card(
              shape: const ContinuousRectangleBorder(),
              elevation: elevation,
              child: bodyItems[index].child,
            ),
          );
        },
        child: child,
      );
    }

    if (items == null || items.isEmpty) {
      return const Text(
        'No items yet',
        style: TextStyle(fontSize: 18),
      );
    }

    return ReorderableListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      proxyDecorator: proxyDecorator,
      buildDefaultDragHandles: true,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
          ref.read(setGroupBodyProvider({
            'groupUid': widget.group.uid,
            'body': items,
          }));
        });
      },
      children: bodyItems,
    );
  }
}
