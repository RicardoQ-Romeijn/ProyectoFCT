// ignore_for_file: file_names

import 'package:flutter_application/Models/Experiences.dart';

class Collections {
  Collections(
    this.id,
    this.image,
    this.title,
    this.experiences,
  );

  String id;
  String image;
  String title;
  List<Experiences> experiences;

  get name => null;
}
