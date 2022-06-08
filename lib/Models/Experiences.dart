// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Experiences {
  Experiences(
    this.id,
    this.image,
    this.title,
    this.description,
    this.location,
    this.date,
  );

  String id;
  String image;
  String title;
  String description;
  GeoPoint location;
  Timestamp date;
}
