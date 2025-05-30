import 'package:flutter/material.dart';
import 'package:ahouefa/ui/predict/widgets/predict_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
            Center(child: Text("Hey, I'm Parfait")),
          ],
        ),
      ),
    );
  }
}
