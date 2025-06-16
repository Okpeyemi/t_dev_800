import 'package:ahouefa/ui/home/widgets/home_screen.dart';
import 'package:flutter/material.dart';

class App extends MaterialApp {
  App({super.key})
    : super(
        title: 'Ahouefa',
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      );
}
