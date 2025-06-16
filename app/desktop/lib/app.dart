import 'package:ahouefa/ui/home/widgets/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(true);
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'Ahouefa',
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      },
    );
  }
}
