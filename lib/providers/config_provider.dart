

import 'package:flutter/material.dart';
import 'package:playground_2502/services/shared_preferences.dart';

class ConfigurationData extends ChangeNotifier {
final SharedPreferencesService _prefsService;
 int _size = 12;

 int get size => _size;

 ConfigurationData(this._prefsService) {
    _loadPreferences();
  }

 void setSize(sizeParam) {
   _size = sizeParam;
   _prefsService.setSize(sizeParam);
   notifyListeners();
 }

   Future<void> _loadPreferences() async {
    _size = await _prefsService.getSize();
    notifyListeners();
  }

}