// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Experience/MasterDetail/collection_list.dart';
import 'package:Experience/Models/Collections.dart';
import 'package:uuid/uuid.dart';

final user = FirebaseAuth.instance.currentUser!;

Scaffold getCollectionPage(BuildContext context) {
  return Scaffold(
    body: CollectionList(),
  );
}
