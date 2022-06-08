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
//       'https://www.simplemost.com/wp-content/uploads/2020/01/AdobeStock_242368501-e1578589210416.jpeg',
//       'Tulip Field',
//       'Nice field with Windmill in background',
//       'Amsterdam',
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

final user = FirebaseAuth.instance.currentUser!;

class CollectionList extends StatefulWidget {
  const CollectionList({Key? key}) : super(key: key);

  @override
  State<CollectionList> createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.all(20),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Collections> collections = [];
          if (snapshot.hasData) {
            for (var element in snapshot.data!.docs.toList()) {
              if (user.uid == element.id) {
                for (var element in element.get('collections')) {
                  var col = Collections(
                    element['title'].toString(),
                    element['image'].toString(),
                  );
                  col.addExperiences(element['experiences']);
                  collections.add(col);
                }
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
                              collectionName: collections[index].title),
                        ),
                      );
                    },
                    child: Scaffold(
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(collections[index].image),
                                ),
                              ),
                            ),
                          ),
                          Text(collections[index].title)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
