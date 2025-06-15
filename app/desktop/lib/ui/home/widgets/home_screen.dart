import 'package:ahouefa/ui/annotate/widgets/annotate_screen.dart';
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
          leading: Icon(Icons.abc, size: 44),
          actions: [
            IconButton(
              onPressed: null,
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
