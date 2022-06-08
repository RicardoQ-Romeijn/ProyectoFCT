// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application/Models/Experiences.dart';
import 'package:folding_cell/folding_cell/widget.dart';

class FrontExperience extends StatelessWidget {
  final String image;
  const FrontExperience({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          color: Color(0xFFffcd3c),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Image.network(
                image,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Icon(
                    Icons.error,
                    color: Color.fromRGBO(0, 0, 0, .3),
                    size: 100,
                  );
                },
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: TextButton(
                  onPressed: () {
                    final foldingCellState = context
                        .findAncestorStateOfType<SimpleFoldingCellState>();
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
              Align(
                alignment: Alignment.center,
                child: Image.network(
                  experience.image,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Color.fromRGBO(0, 0, 0, .3),
                      size: 100,
                    );
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  niceText(experience.title),
                  niceText(experience.description),
                  niceText(experience.location.toString()),
                  niceText(experience.date.toString()),
                ],
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: TextButton(
                  onPressed: () {
                    final foldingCellState = context
                        .findAncestorStateOfType<SimpleFoldingCellState>();
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
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        decorationColor: Colors.transparent,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 0,
        backgroundColor: Colors.white,
      ),
    );
  }
}
