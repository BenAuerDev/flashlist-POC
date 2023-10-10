import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Group {
  final String title;
  final Timestamp createdAt;
  final String uid;
  final Color? color;
  final List<dynamic> array;
  final Map<String, dynamic> permissions;

  Group(
    this.title,
    this.createdAt,
    this.uid,
    this.color,
    this.array,
    this.permissions,
  );
}
