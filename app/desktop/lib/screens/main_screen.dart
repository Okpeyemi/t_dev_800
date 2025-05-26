import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_app_bar.dart';
import 'tabs/analyze_photo_tab.dart';
import 'tabs/submit_case_tab.dart';
import 'user_history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'ahouefa',
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Analyser des radios'),
            Tab(text: 'Soumettre une prédiction'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [AnalyzePhotoTab(), SubmitCaseTab()],
      ),
    );
  }
}
