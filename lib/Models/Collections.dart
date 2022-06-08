// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/Models/Experiences.dart';
import 'package:flutter_application/Utils.dart';
import 'package:uuid/uuid.dart';

class Collections {
  Collections(this.title, this.image);

  String id = const Uuid().v4();
  String image;
  String title;
  List<Experiences> experiences = [];

  addExperiences(dynamic exps) {
    for (var element in exps) {
      Experiences newExp = Experiences(
        element['title'].toString(),
        element['description'].toString(),
        element['image'].toString(),
      );

      Utils.getGeoLocationPosition().then((value) => {
            newExp.setLocation(value.latitude, value.longitude),
            experiences.add(newExp)
            //   print(newExp.convertObj())
          });
    }
  }

  dynamic convertObj() {
    return {
      'id': this.id,
      'title': this.title,
      'image': this.image,
      'experiences': this.experiences
    };
  }
}
