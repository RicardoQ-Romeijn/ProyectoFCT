// ignore_for_file: prefer_const_constructors

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/MasterDetail/experience_card.dart';
import 'package:flutter_application/Models/Collections.dart';
import 'package:flutter_application/Models/Experiences.dart';
import 'package:flutter_application/Utils.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:uuid/uuid.dart';

class ExperienceList extends StatefulWidget {
  final Map<String, Experiences> experiences;
  final String collectionName;
  final String collectionUUID;

  const ExperienceList(
      {Key? key,
      required this.experiences,
      required this.collectionName,
      required this.collectionUUID})
      : super(key: key);

  @override
  State<ExperienceList> createState() =>
      _ExperienceListState(experiences, collectionName, collectionUUID);
}

class _ExperienceListState extends State<ExperienceList> {
  _ExperienceListState(this.exp, this.collectionName, this.collectionUUID);
  final Map<String, Experiences> exp;
  final String collectionName;
  final String collectionUUID;

  List<Experiences> experiences = [];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    exp.forEach((key, value) {
      experiences.add(value);
    });
    count = experiences.length;

    return Container(
        color: Color(0xFF2e282a),
        child: Scaffold(
          appBar: AppBar(title: Text(collectionName)),
          body: ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              return SimpleFoldingCell.create(
                frontWidget: FrontExperience(
                  image: experiences[index].image,
                ),
                innerWidget: InnerExperience(experience: experiences[index]),
                cellSize: Size(MediaQuery.of(context).size.width, 125),
                padding: EdgeInsets.all(15),
                animationDuration: Duration(milliseconds: 300),
                borderRadius: 10,
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final titleController = TextEditingController();
                    final descriptionController = TextEditingController();
                    final imageController = TextEditingController();
                    return AlertDialog(
                      scrollable: true,
                      title: Text('New Experience'),
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
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
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
                            Experiences newExp = Experiences(
                              Uuid().v4(),
                              titleController.value.text.trim(),
                              descriptionController.value.text.trim(),
                              imageController.value.text.trim(),
                            );

                            Utils.getGeoLocationPosition().then((value) => {
                                  newExp.setLocation(
                                      value.latitude, value.longitude),
                                  //   print(newExp.convertObj())
                                });

                            Map<String, dynamic> collts = {};
                            Map<String, dynamic>? exprs = {};
                            Map<String, dynamic>? allData = {};

                            final user = FirebaseAuth.instance.currentUser!;
                            var doc = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid);

                            doc.get().then((value) => {
                                  collts = value.get('collections'),
                                  for (dynamic element in collts.values)
                                    {
                                      if (element['title'] == collectionName)
                                        {
                                          exprs = element['experiences'],
                                          exprs!.addEntries([
                                            MapEntry(Uuid().v4(),
                                                newExp.convertObj())
                                          ]),
                                          doc.get().then((value) => {
                                                allData = value.data(),
                                                allData!['collections'] =
                                                    collts,
                                                doc.update(allData!).then(
                                                    (value) => {
                                                          print(
                                                              "DocumentSnapshot successfully updated!"),
                                                          experiences = [],
                                                          experiences
                                                              .add(newExp),
                                                          setState(() {}),
                                                          Navigator.pop(
                                                              context, true)
                                                        },
                                                    onError: (e) => print(
                                                        "Error updating document $e"))
                                              }),
                                        }
                                    },
                                });
                          },
                        )
                      ],
                    );
                  });
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}
