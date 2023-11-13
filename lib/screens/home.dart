import 'package:flashlist/routing/app_router.dart';
import 'package:flashlist/screens/tabs/groups_list.dart';
import 'package:flashlist/screens/tabs/notifications.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/notification/notification_badge.dart';
import 'package:flashlist/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            retrieveAppLocalizations(context).yourLists,
            textAlign: TextAlign.center,
          ),
        ),
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
        child: TabBar(
          indicatorColor: retrieveColorScheme(context).onBackground,
          labelColor: retrieveColorScheme(context).onBackground,
          tabs: const [
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
        onPressed: () => context.goNamed(AppRoute.addGroup.name),
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
