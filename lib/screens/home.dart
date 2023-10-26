import 'package:flash_list/screens/group_form.dart';
import 'package:flash_list/screens/tabs/groups_list.dart';
import 'package:flash_list/screens/tabs/notifications.dart';
import 'package:flash_list/utils/context_retriever.dart';
import 'package:flash_list/widgets/notification/notification_badge.dart';
import 'package:flash_list/widgets/side_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        actions: const [
          SizedBox(width: 50),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: retrieveColorScheme(context).background,
          boxShadow: [
            BoxShadow(
              color: retrieveColorScheme(context).onBackground,
              spreadRadius: -5,
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.list_alt),
            ),
            Tab(
              icon: NotificationBadge(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: retrieveColorScheme(context).background,
        onPressed: goToGroupForm,
        child: const Icon(Icons.add_card),
      ),
      drawer: const SideDrawer(),
      body: const TabBarView(
        children: [
          GroupsList(),
          NotificationsTab(),
        ],
      ),
    );
  }
}
