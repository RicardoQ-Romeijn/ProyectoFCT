// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/MasterDetail/collection_list.dart';

final db = FirebaseFirestore.instance;

readData() async {
  await db.collection("users").get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
    }
  });
}

Scaffold getCollectionPage() {
  readData();

  return Scaffold(
    body: CollectionList(),
  );
}
