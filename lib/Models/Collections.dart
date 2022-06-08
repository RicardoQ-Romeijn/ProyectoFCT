// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/Models/Experiences.dart';
import 'package:flutter_application/Utils.dart';
import 'package:uuid/uuid.dart';

class Collections {
  Collections(this.uuid, this.title, this.image);

  String uuid;
  String image;
  String title;
  Map<String, Experiences> experiences = {};

  addExperiences(Map<String, dynamic> exps) {
    // print(exps);
    exps.forEach((key, value) {
      Experiences newExp = Experiences(
        key,
        value['title'].toString(),
        value['description'].toString(),
        value['image'].toString(),
      );
      newExp.setGeoLocation(value['location']);
      newExp.setTime(value['date']);
      experiences.addEntries([MapEntry(key, newExp)]);
    });
  }

  dynamic convertObj() {
    return {'title': title, 'image': image, 'experiences': experiences};
  }
}
