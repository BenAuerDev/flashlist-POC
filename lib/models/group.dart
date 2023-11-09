import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  final List<dynamic> body;
  final GroupPermissions permissions;

  Group(
    this.title,
    this.createdAt,
    this.uid,
    this.color,
    this.body,
    this.permissions,
  );
}

class GroupDTO {
  final String title;
  final Color? color;
  final String? uid;

  GroupDTO(this.title, this.color, [this.uid]);
}
