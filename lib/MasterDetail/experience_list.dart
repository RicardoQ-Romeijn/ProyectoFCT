// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application/MasterDetail/experience_card.dart';
import 'package:flutter_application/Models/Experiences.dart';
import 'package:folding_cell/folding_cell/widget.dart';

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
        ));
  }
}
