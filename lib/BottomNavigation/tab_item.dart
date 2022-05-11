import 'package:flutter/material.dart';

enum TabItem { collection, profile }

const Map<TabItem, String> tabName = {
  TabItem.collection: 'Collection',
  TabItem.profile: 'Profile',
};

const Map<TabItem, MaterialColor> activeTabColor = {
  TabItem.collection: Colors.green,
  TabItem.profile: Colors.blue,
};

const Map<TabItem, Icon> tabIcon = {
  TabItem.collection: Icon(Icons.collections),
  TabItem.profile: Icon(Icons.person_pin_rounded),
};
