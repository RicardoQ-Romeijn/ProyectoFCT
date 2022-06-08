// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/MasterDetail/collection_list.dart';
import 'package:flutter_application/Models/Collections.dart';
import 'package:uuid/uuid.dart';

final user = FirebaseAuth.instance.currentUser!;

Scaffold getCollectionPage(BuildContext context) {
  return Scaffold(
    body: CollectionList(),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              final titleController = TextEditingController();
              final imageController = TextEditingController();
              return AlertDialog(
                scrollable: true,
                title: Text('New Collection'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            icon: Icon(Icons.text_fields),
                          ),
                        ),
                        TextFormField(
                          controller: imageController,
                          decoration: InputDecoration(
                            labelText: 'Image',
                            icon: Icon(Icons.image),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text("Create"),
                    onPressed: () {
                      var snapshot = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .snapshots();
                      snapshot.forEach((element) {
                        List<dynamic> col = element
                            .data()
                            ?.putIfAbsent('collections', () => []);

                        Collections newCol = Collections(
                          Uuid().v4(),
                          imageController.value.text.trim(),
                          titleController.value.text.trim(),
                        );

                        col.add(newCol.convertObj());
                        element.data()?.update('collections', (value) => col);

                        // MapEntry<String, dynamic> map =
                        //     MapEntry('collections', newCol.convertObj());
                        // Iterable<MapEntry<String, dynamic>> iterable = [map];
                        // element.data()!.addEntries(iterable);

                        Navigator.pop(context, true);
                      });
                    },
                  )
                ],
              );
            });
      },
      child: const Icon(Icons.add),
    ),
  );
}
