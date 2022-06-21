// ignore_for_file: file_names

import 'package:Experience/Models/Collections.dart';

class Users {
  Users(
    this.displayName,
    this.email,
    this.collections,
  );

  String displayName;
  String email;
  Map<String, Collections> collections;
}
