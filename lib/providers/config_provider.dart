

import 'package:flutter/material.dart';

class ConfigurationData extends ChangeNotifier {
 int _size = 12;

 int get size => _size;

 void setSize(sizeParam) {
   _size = sizeParam;
   notifyListeners();
 }

}