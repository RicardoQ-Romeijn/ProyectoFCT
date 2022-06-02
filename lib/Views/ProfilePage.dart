// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final user = FirebaseAuth.instance.currentUser!;

Scaffold getProfilePage() {
  return Scaffold(
    body: Column(
      children: [
        prettyText('User: ', user.displayName),
        prettyText('Email: ', user.email),
        prettyText('Photo: ', user.photoURL),
        prettyText('UID: ', user.uid),
        prettyText('Phone: ', user.phoneNumber),
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
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ),
      ],
    ),
  );
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