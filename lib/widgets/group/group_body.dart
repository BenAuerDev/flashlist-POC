import 'dart:ui';

import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DismissibleDragAndDropList extends ConsumerStatefulWidget {
  const DismissibleDragAndDropList({super.key, required this.group});

  final Group group;

  @override
  ConsumerState<DismissibleDragAndDropList> createState() {
    return _DragAndDropListState();
  }
}

class _DragAndDropListState extends ConsumerState<DismissibleDragAndDropList> {
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

    void onDismissItem(item) async {
      final oldState = items.toList();
      final index = items.indexOf(item);

      setState(() {
        items.remove(item);
      });

      final response = await ref
          .read(firestoreServiceProvider)
          .removeItemFromGroupBody(widget.group.uid, item);

      if (response) {
        showSnackbar(
          'Item removed',
          SnackBarAction(
            label: 'Undo',
            onPressed: () {
              ref
                  .read(firestoreServiceProvider)
                  .setGroupBody(widget.group.uid, oldState);
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
              onDismissed: (direction) {
                onDismissItem(items[index]);
              },
              background: Container(
                color: retrieveColorScheme(context).error.withOpacity(0.5),
                margin: EdgeInsets.symmetric(
                  vertical:
                      retrieveTheme(context).cardTheme.margin!.vertical / 2,
                ),
              ),
              child: Card(
                shape: const ContinuousRectangleBorder(),
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
          ref
              .read(firestoreServiceProvider)
              .setGroupBody(widget.group.uid, items);
        });
      },
      children: bodyItems,
    );
  }
}
