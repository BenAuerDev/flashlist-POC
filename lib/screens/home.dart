import 'package:brainstorm_array/models/group.dart';
import 'package:brainstorm_array/providers/providers.dart';
import 'package:brainstorm_array/screens/group_form.dart';
import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:brainstorm_array/widgets/group/group_wrapper.dart';
import 'package:brainstorm_array/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goToGroupForm() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const GroupForm(),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Your Lists')),
          actions: [
            IconButton(
              onPressed: goToGroupForm,
              icon: const Icon(Icons.add_card),
            ),
          ],
        ),
        drawer: const SideDrawer(),
        body: StreamBuilder(
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
              return Stack(
                children: [
                  Center(
                    child: ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return GroupWrapper(group: group);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      backgroundColor: retrieveColorScheme(context).background,
                      onPressed: goToGroupForm,
                      child: const Icon(Icons.add_card),
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }
}
