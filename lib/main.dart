import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playground_2502/providers/config_provider.dart';
import 'package:playground_2502/screens/my_home_page.dart';
import 'package:playground_2502/services/shared_preferences.dart';
import 'package:playground_2502/theme/theme.dart';
import 'package:playground_2502/utils/util.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "ABeeZee", "Aleo");
     MaterialTheme theme = MaterialTheme(textTheme);

    return ChangeNotifierProvider<ConfigurationData>(
      create: (context) => ConfigurationData(SharedPreferencesService()),
      child: MaterialApp(
        title: '3479A321_202502',
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        home: const MyHomePage(title: '3479A321_202502'),
        //home: ListCreationScreen(),
      ), 
    );
  }
}

