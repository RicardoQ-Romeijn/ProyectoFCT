// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Experiences {
  Experiences(
    this.uuid,
    this.title,
    this.description,
    this.image,
  );

  String uuid;
  String image;
  String title;
  String description;
  GeoPoint location = const GeoPoint(0, 0);
  Timestamp date = Timestamp.now();

  setLocation(latitude, longitude) {
    location = GeoPoint(latitude, longitude);
  }

  setGeoLocation(GeoPoint location) {
    location = location;
  }

  setTime(Timestamp date) {
    date = date;
  }

  dynamic convertObj() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'location': location,
      'date': date,
    };
  }
}
