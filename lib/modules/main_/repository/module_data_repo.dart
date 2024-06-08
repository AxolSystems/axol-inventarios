import 'package:flutter/material.dart';

class DBModule {
 static String get table => 'modules';
 static String get id => 'id';
 static String get text => 'text';
 static String get position => 'position';
 static String get icon => 'icon';
 static String get permissions => 'permissions';
 static String get menu => 'menu';
}

class IconsModule {
  static IconData getIcon(int value) {
    switch (value) {
      case 0:
        return Icons.home;
      default:
        return Icons.square;
    }
  }
}
