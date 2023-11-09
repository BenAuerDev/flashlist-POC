import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupBodyItem {
  final String name;
  final String uid;

  GroupBodyItem({required this.name, required this.uid});

  @override
  String toString() => name;
}

class GroupPermissions {
  final String owner;
  final List<String> editors;

  GroupPermissions(this.owner, this.editors);
}

class Group {
  final String title;
  final Timestamp createdAt;
  final String uid;
  final Color? color;
  final List<GroupBodyItem> body;
  final GroupPermissions permissions;

  Group(
    this.title,
    this.createdAt,
    this.uid,
    this.color,
    this.body,
    this.permissions,
  );

  @override
  String toString() => title;
}

class GroupDTO {
  final String title;
  final Color? color;
  final String? uid;

  GroupDTO(this.title, this.color, [this.uid]);
}
