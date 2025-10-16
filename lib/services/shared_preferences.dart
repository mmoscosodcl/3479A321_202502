import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> setSize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('grid_size', size);
  }

  Future<int> getSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('grid_size') ?? 16; // Default to 16 if not set
  }

}