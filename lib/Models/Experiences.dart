// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Experiences {
  Experiences(
    this.title,
    this.description,
    this.image,
  );

  String id = const Uuid().v4();
  String image;
  String title;
  String description;
  GeoPoint location = const GeoPoint(0, 0);
  Timestamp date = Timestamp.now();

  setLocation(latitude, longitude) {
    location = GeoPoint(latitude, longitude);
  }

  dynamic convertObj() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'location': location,
      'date': date
    };
  }
}
