// ignore_for_file: file_names

import 'package:flutter_application/Models/Collections.dart';

class Users {
  Users(
    this.displayName,
    this.email,
    this.collections,
  );

  String displayName;
  String email;
  List<Collections> collections;
}
