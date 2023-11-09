import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupBodyItem {
  const GroupBodyItem({required this.name, required this.uid});

  final String name;
  final String uid;

  @override
  String toString() => name;
}

class GroupPermissions {
  GroupPermissions(this.owner, this.editors);

  final String owner;
  final List<String> editors;
}

class Group {
  Group(
    this.title,
    this.createdAt,
    this.uid,
    this.color,
    this.body,
    this.permissions,
  );

  final String title;
  final Timestamp createdAt;
  final String uid;
  final Color? color;
  final List<GroupBodyItem> body;
  final GroupPermissions permissions;

  @override
  String toString() => title;
}

class GroupDTO {
  GroupDTO(this.title, this.color, [this.uid]);

  final String title;
  final Color? color;
  final String? uid;

  @override
  String toString() => title;
}
