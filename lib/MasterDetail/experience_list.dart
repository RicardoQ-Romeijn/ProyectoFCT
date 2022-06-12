// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/MasterDetail/collection_list.dart';
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

  const ExperienceList({Key? key, required this.experiences, required this.collectionName, required this.collectionUUID}) : super(key: key);

  @override
  State<ExperienceList> createState() => _ExperienceListState(experiences, collectionName, collectionUUID);
}

class _ExperienceListState extends State<ExperienceList> {
  _ExperienceListState(this.exp, this.collectionName, this.collectionUUID);
  final Map<String, Experiences> exp;
  final String collectionName;
  final String collectionUUID;

  int count = 0;
  List<Experiences> experiences = [];

  @override
  Widget build(BuildContext context) {
    exp.forEach((key, value) {
      experiences.add(value);
    });
    return Container(
        color: Color(0xFF2e282a),
        child: Scaffold(
          appBar: AppBar(title: Text(collectionName)),
          // deberia de haber utilizado StreamBuilder pero no hay tiempo de cambiarlo
          body: ListView.builder(
            itemCount: experiences.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: SimpleFoldingCell.create(
                  frontWidget: FrontExperience(
                    experience: experiences[index],
                  ),
                  innerWidget: InnerExperience(
                    experience: experiences[index],
                  ),
                  cellSize: Size(MediaQuery.of(context).size.width, 125),
                  padding: EdgeInsets.all(15),
                  animationDuration: Duration(milliseconds: 300),
                  borderRadius: 10,
                ),
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: false,
                          title: Text('Confirmation'),
                          content:
                              Padding(padding: const EdgeInsets.all(8.0), child: Text('You sure you want to delete ${experiences[index].title}?')),
                          actions: [
                            ElevatedButton(
                              child: Text("Delete"),
                              onPressed: () {
                                Map<String, dynamic> collts = {};
                                Map<String, dynamic>? allData = {};
                                Map<String, dynamic>? exprs = {};
                                Map<String, dynamic>? copyExprs = {};
                                List<Experiences> copyExperiences = [];
                                for (var element in experiences) {
                                  copyExperiences.add(element);
                                }
                                String tempKey;

                                var doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

                                doc.get().then((value) => {
                                      collts = value.get('collections'),
                                      for (dynamic element in collts.keys)
                                        {
                                          if (element == collectionUUID)
                                            {
                                              exprs = value.get('collections.$element.experiences'),
                                              copyExprs = collts[element]['experiences'],
                                              for (dynamic element in copyExprs!.keys)
                                                {
                                                  if (element == experiences[index].uuid)
                                                    {
                                                      tempKey = element,
                                                      exprs!.removeWhere((key, value) => key == tempKey),
                                                      copyExperiences.removeWhere((element) => element.uuid == tempKey),
                                                    }
                                                }
                                            }
                                        },
                                      doc.get().then((value) => {
                                            allData = value.data(),
                                            allData!['collections'][collectionUUID]['experiences'] = exprs,
                                            doc.update(allData!).then(
                                                (value) => {
                                                      print("DocumentSnapshot successfully updated!"),
                                                      setState(() {
                                                        experiences.clear();
                                                        for (var element in copyExperiences) {
                                                          experiences.add(element);
                                                        }
                                                        ;
                                                        Navigator.pop(context, true);
                                                      }),
                                                      Navigator.pop(this.context, true)
                                                    },
                                                onError: (e) => print("Error updating document $e"))
                                          }),
                                    });
                              },
                            )
                          ],
                        );
                      });
                },
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
                                  newExp.setLocation(value.latitude, value.longitude),
                                  //   print(newExp.convertObj())
                                });

                            Map<String, dynamic> collts = {};
                            Map<String, dynamic>? exprs = {};
                            Map<String, dynamic>? allData = {};

                            final user = FirebaseAuth.instance.currentUser!;
                            var doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

                            doc.get().then((value) => {
                                  collts = value.get('collections'),
                                  for (dynamic element in collts.values)
                                    {
                                      if (element['title'] == collectionName)
                                        {
                                          exprs = element['experiences'],
                                          exprs!.addEntries([MapEntry(Uuid().v4(), newExp.convertObj())]),
                                          doc.get().then((value) => {
                                                allData = value.data(),
                                                allData!['collections'] = collts,
                                                doc.update(allData!).then(
                                                    (value) => {
                                                          print("DocumentSnapshot successfully updated!"),
                                                          setState(() {
                                                            experiences.clear();
                                                            experiences.add(newExp);
                                                          }),
                                                          Navigator.pop(context, true)
                                                        },
                                                    onError: (e) => print("Error updating document $e"))
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
