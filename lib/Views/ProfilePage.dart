// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

var user = FirebaseAuth.instance.currentUser!;

var brightness = SchedulerBinding.instance.window.platformBrightness;
bool isDarkMode = brightness == Brightness.dark;

Scaffold getProfilePage(BuildContext context) {
  user = FirebaseAuth.instance.currentUser!;

  return Scaffold(
    body: Column(
      children: [
        _picture(),
        _displayName(),
        _email(),
        _mobile(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            icon: Icon(Icons.arrow_back, size: 32),
            label: Text(
              'Sign Out',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () => _signOut(),
          ),
        ),
      ],
    ),
  );
}

_email() {
  String email = user.email ?? 'Anonymous';

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(children: <Widget>[
      _prefixIcon(Icons.email),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Email',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  color: Colors.grey)),
          SizedBox(height: 1),
          Text(email)
        ],
      )
    ]),
  );
}

_mobile() {
  String phone = user.phoneNumber ?? 'No Number Provided';

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(children: <Widget>[
      _prefixIcon(Icons.phone),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Mobile',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  color: Colors.grey)),
          SizedBox(height: 1),
          Text(phone)
        ],
      )
    ]),
  );
}

_displayName() {
  String displayName = user.displayName ?? 'No Name provided';

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(children: <Widget>[
      _prefixIcon(Icons.text_fields),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Display Name',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  color: Colors.grey)),
          SizedBox(height: 1),
          Text(displayName)
        ],
      )
    ]),
  );
}

_picture() {
  String photoURL = user.photoURL ?? 'noPicture.jpg';

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Image.network(
      photoURL,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Icon(
          Icons.person,
          color: Color.fromRGBO(177, 177, 177, .5),
          size: 100,
        );
      },
    ),
  );
}

_prefixIcon(IconData iconData) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
    child: Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(10.0))),
        child: Icon(
          iconData,
          size: 20,
          color: Colors.grey,
        )),
  );
}

_signOut() async {
  await FirebaseAuth.instance.signOut();
}

prettyText(String preText, String? postText) {
  if (postText == null) return SizedBox(height: 0);

  return RichText(
    text: TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 20, height: 2),
      text: preText,
      children: [
        TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 20),
          text: postText,
        ),
      ],
    ),
  );
}
