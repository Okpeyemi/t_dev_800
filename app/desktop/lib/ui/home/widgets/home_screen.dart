import 'package:ahouefa/app.dart';
import 'package:ahouefa/routes.dart';
import 'package:ahouefa/ui/annotate/widgets/annotate_screen.dart';
import 'package:ahouefa/ui/shared/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:ahouefa/ui/predict/widgets/predict_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Logo(),
          actions: [
            IconButton(
              onPressed: () {
                App.isDarkMode.value = !App.isDarkMode.value;
              },
              icon:
                  App.isDarkMode.value
                      ? Icon(Icons.light_mode)
                      : Icon(Icons.dark_mode),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, Routes.dashboard());
              },
              icon: const Icon(Icons.dashboard, size: 24),
            ),
            IconButton(
              onPressed: null,
              icon: const Icon(Icons.settings, size: 24),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Faire une prédiction"),
              Tab(text: "Soumettre une prédiction"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: PredictScreen()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnnotateScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
