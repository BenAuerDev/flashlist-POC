import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Group {
  final String title;
  final Timestamp createdAt;
  final String uid;
  final Color? color;
  final List<dynamic> body;
  final Map<String, dynamic> permissions;

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
