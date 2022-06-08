// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/Models/Experiences.dart';

class Collections {
  Collections(this.id, this.image, this.title);

  String id;
  String image;
  String title;
  List<Experiences> experiences = [];

  addExperiences(dynamic exps) {
    for (var element in exps) {
      var exp = Experiences(
        element['id'].toString(),
        element['image'].toString(),
        element['title'].toString(),
        element['description'].toString(),
        element['location'],
        element['date'],
      );
      this.experiences.add(exp);
    }
  }

  get name => null;
}
