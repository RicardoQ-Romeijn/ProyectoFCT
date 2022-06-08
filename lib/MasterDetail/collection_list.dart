// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application/MasterDetail/experience_list.dart';
import 'package:flutter_application/Models/Collections.dart';
import 'package:flutter_application/Models/Experiences.dart';
import 'package:flutter_application/Models/Users.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

// final List<Experiences> _experiences = [
//   Experiences(
//       '1',
//       'https://www.schengenvisainfo.com/news/wp-content/uploads/2020/06/Amsterdam-Netherlands.jpg',
//       'Water Canal',
//       'Canal with nice trees and boats',
//       '52.3740300, 4.8896900',
//       "22/04/2022"),
//   Experiences(
//       '2',
//       'http://theimmigrationoffice.com/wp-content/uploads/2015/08/Sidney.jpg',
//       'Australia',
//       'Australian Description',
//       '-25.274398, 133.775136',
//       "22/04/2022"),
//   Experiences(
//       '3',
//       'https://www.simplemost.com/wp-content/uploads/2020/01/AdobeStock_243835834.jpeg',
//       'Bridge',
//       'Nice bridge with a beautiful church in background',
//       'Rotterdam',
//       "22/04/2022")
// ];

// final List<Collections> _items = [
//   Collections(
//       '1',
//       'https://www.netherlands-tourism.com/wp-content/uploads/2013/07/Flag-of-The-Netherlands3.png',
//       'Holland',
//       _experiences),
//   Collections(
//       '2',
//       'https://m.media-amazon.com/images/I/71VC1i3mFrL._AC_SX679_.jpg',
//       'Australia',
//       _experiences),
//   Collections(
//       '3',
//       'https://cdn11.bigcommerce.com/s-2lbnjvmw4d/images/stencil/1280x1280/products/2852/5280/canadaflag__98669.1617275975.jpg',
//       'Canada',
//       _experiences)
// ];

var user = FirebaseAuth.instance.currentUser!;
var snapshots = FirebaseFirestore.instance.collection('users').snapshots();

class CollectionList extends StatefulWidget {
  const CollectionList({Key? key}) : super(key: key);

  @override
  State<CollectionList> createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser!;

    return ListTileTheme(
      contentPadding: EdgeInsets.all(20),
      child: StreamBuilder(
        stream: snapshots,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Collections> collections = [];
          if (snapshot.hasData) {
            for (var element in snapshot.data!.docs.toList()) {
              if (user.uid == element.id) {
                Map<String, dynamic> collectionObj = element.get('collections');
                collectionObj.forEach((key, value) {
                  var col = Collections(
                    key,
                    value['title'].toString(),
                    value['image'].toString(),
                  );
                  col.addExperiences(value['experiences']);
                  collections.add(col);
                });
              }
            }
          }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExperienceList(
                            experiences: collections[index].experiences,
                            collectionName: collections[index].title,
                            collectionUUID: collections[index].uuid,
                          ),
                        ),
                      );
                    },
                    child: Scaffold(
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Image.network(
                                collections[index].image,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Icon(
                                    Icons.error,
                                    color: Color.fromRGBO(0, 0, 0, .3),
                                    size: 100,
                                  );
                                },
                              ),
                            ),
                          ),
                          //   Expanded(
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         image: DecorationImage(
                          //           fit: BoxFit.cover,
                          //           image: NetworkImage(collections[index].image),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          Text(collections[index].title)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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
                              Collections newCol = Collections(
                                Uuid().v4(),
                                titleController.value.text.trim(),
                                imageController.value.text.trim(),
                              );

                              Map<String, dynamic> col;

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .get()
                                  .then((value) => {
                                        col = value.get('collections'),
                                        col.addAll({
                                          '${col.length}': newCol.convertObj()
                                        }),
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user.uid)
                                            .update({'collections': col}).then(
                                                (value) => {
                                                      print(
                                                          "DocumentSnapshot successfully updated!"),
                                                      setState(() {}),
                                                      Navigator.pop(
                                                          context, true)
                                                    },
                                                onError: (e) => print(
                                                    "Error updating document $e")),
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
        },
      ),
    );
  }
}
