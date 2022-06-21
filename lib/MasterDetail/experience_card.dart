// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Experience/Models/Experiences.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:intl/intl.dart';

class FrontExperience extends StatelessWidget {
  final Experiences experience;
  const FrontExperience({Key? key, required this.experience}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          color: Color(0xFFffcd3c),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 0,
                left: 0,
                top: 0,
                bottom: 0,
                child: Image.network(
                  experience.image,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Color.fromRGBO(0, 0, 0, .3),
                      size: 100,
                    );
                  },
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: TextButton(
                  onPressed: () {
                    final foldingCellState = context.findAncestorStateOfType<SimpleFoldingCellState>();
                    foldingCellState?.toggleFold();
                  },
                  child: Text(
                    "Open",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(150, 255, 255, 255),
                    minimumSize: Size(80, 40),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class InnerExperience extends StatelessWidget {
  final Experiences experience;
  const InnerExperience({Key? key, required this.experience}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          color: Color(0xFFecf2f9),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.network(
                        experience.image,
                        fit: BoxFit.fitHeight,
                        width: MediaQuery.of(context).size.width / 2,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const Icon(
                            Icons.error,
                            color: Color.fromRGBO(0, 0, 0, .3),
                            size: 100,
                          );
                        },
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          niceText(experience.title),
                          niceText(experience.description),
                          //   Text(
                          //       '${experience.location.latitude.toString()}, ${experience.location.longitude.toString()}'),
                          niceText(DateFormat('yyyy-MM-dd').format(DateTime.fromMicrosecondsSinceEpoch(experience.date.microsecondsSinceEpoch))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: TextButton(
                  onPressed: () {
                    final foldingCellState = context.findAncestorStateOfType<SimpleFoldingCellState>();
                    foldingCellState?.toggleFold();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(150, 255, 255, 255),
                    minimumSize: Size(80, 40),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  niceText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        decorationColor: Colors.transparent,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 0,
      ),
    );
  }
}
