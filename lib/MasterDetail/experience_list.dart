// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application/MasterDetail/experience_card.dart';
import 'package:flutter_application/Models/Experiences.dart';
import 'package:folding_cell/folding_cell/widget.dart';

class ExperienceList extends StatefulWidget {
  final List<Experiences> experiences;
  const ExperienceList({Key? key, required this.experiences}) : super(key: key);

  @override
  State<ExperienceList> createState() => _ExperienceListState(experiences);
}

class _ExperienceListState extends State<ExperienceList> {
  _ExperienceListState(this.experiences);
  final List<Experiences> experiences;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2e282a),
      child: ListView.builder(
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
    );
  }
}
