import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playground_2502/providers/config_provider.dart';
import 'package:playground_2502/screens/my_home_page.dart';
import 'package:playground_2502/services/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<ConfigurationData>(
      create: (context) => ConfigurationData(SharedPreferencesService()),
      child: MaterialApp(
        title: '3479A321_202502',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          textTheme: TextTheme(
            displayLarge: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
            // ···
            titleLarge: GoogleFonts.oswald(
              fontSize: 30,
              fontStyle: FontStyle.italic,
            ),
            bodyMedium: GoogleFonts.merriweather(),
            displaySmall: GoogleFonts.pacifico(),
          )
        ),
        home: const MyHomePage(title: '3479A321_202502'),
        //home: ListCreationScreen(),
      ), 
    );
  }
}

