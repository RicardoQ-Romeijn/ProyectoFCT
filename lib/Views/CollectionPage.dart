// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/MasterDetail/collection_list.dart';

final user = FirebaseAuth.instance.currentUser!;

Scaffold getCollectionPage() {
  return Scaffold(
    body: CollectionList(),
  );
}
