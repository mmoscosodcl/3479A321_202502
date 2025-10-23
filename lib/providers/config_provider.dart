import 'package:flutter/material.dart';
import 'package:playground_2502/services/shared_preferences.dart';
import 'dart:typed_data';

class ConfigurationData with ChangeNotifier {
  final SharedPreferencesService _prefsService;
  int _size = 12;
  final List<String> _creations = [];
  double _backgroundOpacity = 0.5;

  int get size => _size;
  List<String> get creations => _creations;
  double get backgroundOpacity => _backgroundOpacity;

  ConfigurationData(this._prefsService) {
    _loadPreferences();
  }

  void setSize(sizeParam) {
    _size = sizeParam;
    _prefsService.setSize(sizeParam);
    notifyListeners();
  }

  void addCreation(String filePath) {
    _creations.add(filePath);
    notifyListeners();
  }

  void setBackgroundOpacity(double opacity) {
    _backgroundOpacity = opacity;
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    _size = await _prefsService.getSize();
    notifyListeners();
  }
}