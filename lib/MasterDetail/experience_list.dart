// ignore_for_file: prefer_const_constructors

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/MasterDetail/experience_card.dart';
import 'package:flutter_application/Models/Experiences.dart';
import 'package:flutter_application/Utils.dart';
import 'package:folding_cell/folding_cell/widget.dart';

final user = FirebaseAuth.instance.currentUser!;

class ExperienceList extends StatefulWidget {
  final List<Experiences> experiences;
  final String collectionName;
  const ExperienceList(
      {Key? key, required this.experiences, required this.collectionName})
      : super(key: key);

  @override
  State<ExperienceList> createState() =>
      _ExperienceListState(experiences, collectionName);
}

class _ExperienceListState extends State<ExperienceList> {
  _ExperienceListState(this.experiences, this.collectionName);
  final List<Experiences> experiences;
  final String collectionName;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF2e282a),
        child: Scaffold(
          appBar: AppBar(title: Text(collectionName)),
          body: ListView.builder(
            itemCount: experiences.length,
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
                              titleController.value.text.trim(),
                              descriptionController.value.text.trim(),
                              imageController.value.text.trim(),
                            );

                            Utils.getGeoLocationPosition().then((value) => {
                                  newExp.setLocation(
                                      value.latitude, value.longitude),
                                  //   print(newExp.convertObj())
                                });

                            var snapshot = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .get();

                            List<dynamic> collections = [];
                            List<dynamic> experiences = [];

                            snapshot.then(
                              (value) => {
                                collections = value.get('collections'),
                                collections.forEach((element) {
                                  if (element['title'] == collectionName) {
                                    experiences = element['experiences'];
                                    experiences.add(newExp.convertObj());
                                    print(experiences);
                                  }
                                })
                              },
                            );
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
