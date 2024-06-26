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

/// Clase que devuelve un icono para el módulo según 
/// en índice numérico proporcionado.
class IconsRepo {
  /// Devuelve un icono según el número proporcionado.
  static IconData getIcon(int value) {
    if (value == Icons.home.codePoint) {
      return Icons.home;
    } else {
      return Icons.square;
    }
  }
}
