import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';

class AnalyzePhotoTab extends StatefulWidget {
  const AnalyzePhotoTab({super.key});

  @override
  _AnalyzePhotoTabState createState() => _AnalyzePhotoTabState();
}

class _AnalyzePhotoTabState extends State<AnalyzePhotoTab> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  bool _isAnalyzing = false;
  bool _showResults = false;
  String _analysisResults = "";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (_showResults) {
      _animationController.forward();
      // Vue des résultats d'analyse
      return FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Barre supérieure avec boutons de navigation
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF252525) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _animationController.reverse().then((_) {
                          setState(() {
                            _showResults = false;
                            _isAnalyzing = false;
                          });
                        });
                      },
                      icon: Icon(Icons.arrow_back, size: 18),
                      label: Text('Retour'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Spacer(),
                    // Bouton pour redémarrer l'analyse
                    ElevatedButton.icon(
                      onPressed: _analyzePhotos,
                      icon: Icon(Icons.refresh, size: 18),
                      label: Text('Relancer l\'analyse'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contenu principal divisé en deux colonnes
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Colonne 1: Images
                    Expanded(
                      child: Card(
                        margin: EdgeInsets.all(16),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    color: Theme.of(context).primaryColor,
                                    size: 22,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Images analysées',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1),
                            Expanded(
                              child: _images.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 48,
                                            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Aucune image à analyser',
                                            style: TextStyle(
                                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _images.length == 1
                                      ? Container(
                                          margin: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.03),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.file(
                                              File(_images[0].path),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        )
                                      : GridView.builder(
                                          padding: EdgeInsets.all(16),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                            childAspectRatio: 1,
                                          ),
                                          itemCount: _images.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.03),
                                                    blurRadius: 8,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.file(
                                                  File(_images[index].path),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Colonne 2: Analyse et Résultats
                    Expanded(
                      child: Column(
                        children: [
                          // Ligne 1: État de l'analyse
                          Expanded(
                            flex: 1,
                            child: Card(
                              margin: EdgeInsets.fromLTRB(0, 16, 16, 8),
                              elevation: 4,
                              shadowColor: Colors.black.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.query_stats,
                                          color: Theme.of(context).primaryColor,
                                          size: 22,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'État de l\'analyse',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 1),
                                  Expanded(
                                    child: Center(
                                      child: _isAnalyzing
                                          ? Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: CircularProgressIndicator(
                                                    color: Theme.of(context).primaryColor,
                                                    strokeWidth: 3,
                                                  ),
                                                ),
                                                SizedBox(height: 24),
                                                Text(
                                                  'Analyse en cours...',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Veuillez patienter',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[50],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green[700],
                                                    size: 40,
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Text(
                                                  'Analyse terminée',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green[700],
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Résultats disponibles ci-dessous',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Ligne 2: Résultats
                          Expanded(
                            flex: 2,
                            child: Card(
                              margin: EdgeInsets.fromLTRB(0, 8, 16, 16),
                              elevation: 4,
                              shadowColor: Colors.black.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.analytics_outlined,
                                          color: Theme.of(context).primaryColor,
                                          size: 22,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Résultats',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 1),
                                  Expanded(
                                    child: _isAnalyzing
                                        ? Center(
                                            child: Text(
                                              'En attente de résultats...',
                                              style: TextStyle(
                                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                fontSize: 15,
                                              ),
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Carte de résultat: Détection
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.03),
                                                        blurRadius: 3,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red[50],
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.medical_information,
                                                          color: Colors.red[700],
                                                          size: 24,
                                                        ),
                                                      ),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Détection',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              'Présence de pneumonie',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: isDarkMode ? Colors.white : Colors.black87,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                                
                                                // Carte de résultat: Probabilité
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.03),
                                                        blurRadius: 3,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.orange[50],
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.assessment,
                                                          color: Colors.orange[700],
                                                          size: 24,
                                                        ),
                                                      ),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Probabilité',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              '87%',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: isDarkMode ? Colors.white : Colors.black87,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                                
                                                // Carte de résultat: Classification
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.03),
                                                        blurRadius: 3,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.purple[50],
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.category,
                                                          color: Colors.purple[700],
                                                          size: 24,
                                                        ),
                                                      ),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Classification',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              'Pneumonie bactérienne',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: isDarkMode ? Colors.white : Colors.black87,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                
                                                SizedBox(height: 24),
                                                
                                                // Section Recommandations
                                                Text(
                                                  'Recommandations:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                
                                                // Liste de recommandations
                                                Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle_outline,
                                                            color: Colors.green[700],
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            child: Text(
                                                              'Consultation médicale recommandée',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 12),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle_outline,
                                                            color: Colors.green[700],
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            child: Text(
                                                              'Traitement antibiotique potentiellement nécessaire',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                
                                                SizedBox(height: 16),
                                                
                                                // Note sur le modèle
                                                Container(
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode ? Color(0xFF1A2634) : Color(0xFFEFF8FF),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: isDarkMode ? Color(0xFF234563) : Color(0xFFD1E6FA),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        size: 18,
                                                        color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          'Cette analyse a été effectuée avec le modèle v2.3',
                                                          style: TextStyle(
                                                            fontStyle: FontStyle.italic,
                                                            fontSize: 13,
                                                            color: isDarkMode ? Colors.blue[100] : Colors.blue[900],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                
                                                SizedBox(height: 16),
                                                
                                                // Bouton d'exportation des résultats
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: OutlinedButton.icon(
                                                    onPressed: () {
                                                      // Logique d'exportation
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Résultats exportés avec succès'),
                                                          backgroundColor: Colors.green,
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(Icons.download_outlined),
                                                    label: Text('Exporter les résultats'),
                                                    style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(vertical: 12),
                                                      side: BorderSide(
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Vue d'upload améliorée
      return Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et description avec style amélioré
            Text(
              'Analyser des radiographies pulmonaires',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Téléchargez des images de radiographie pulmonaire pour détecter des signes de pneumonie.',
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                height: 1.4,
              ),
            ),
            SizedBox(height: 32),
            
            // Zone d'upload améliorée
            InkWell(
              onTap: _pickImages,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DashedBorder(
                  padding: EdgeInsets.all(16), // Réduit de 24 à 16
                  borderRadius: 12,
                  color: isDarkMode ? Colors.grey[600]! : Colors.grey[400]!,
                  dashPattern: [6, 4],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Ajout de cette ligne
                      children: [
                        Container(
                          padding: EdgeInsets.all(12), // Réduit de 16 à 12
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 32, // Réduit de 36 à 32
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 12), // Réduit de 16 à 12
                        Text(
                          "Ajouter des radiographies",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 2), // Réduit de 4 à 2
                        Text(
                          "Formats supportés: JPEG, PNG",
                          style: TextStyle(
                            fontSize: 12, // Réduit de 13 à 12
                            color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Images téléchargées
            Expanded(
              child: _images.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Aucune image téléchargée',
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey[600] : Colors.grey[500],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(_images[index].path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _images.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Badge indiquant le format/type de l'image
                              Positioned(
                                left: 8,
                                bottom: 8,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _getFileExtension(_images[index].name),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 24),
            
            // Bouton d'analyse amélioré
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _images.isEmpty ? null : _analyzePhotos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  disabledForegroundColor: isDarkMode ? Colors.grey[600] : Colors.grey[500],
                  elevation: isDarkMode ? 0 : 2,
                  shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isAnalyzing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'ANALYSE EN COURS...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'ANALYSER LES IMAGES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    }
  }

  String _getFileExtension(String fileName) {
    return fileName.split('.').last.toUpperCase();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        setState(() {
          _images.addAll(selectedImages);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Erreur lors de la sélection des images: $e')),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _analyzePhotos() async {
    setState(() {
      _isAnalyzing = true;
      _showResults = true;
      _animationController.reset();
    });

    // Simuler l'analyse
    await Future.delayed(Duration(seconds: 3));

    // Simuler des résultats
    _analysisResults = "Résultats de l'analyse :\n\n"
        "- Détection: Présence de pneumonie\n"
        "- Probabilité: 87%\n"
        "- Classification: Pneumonie bactérienne\n\n"
        "Recommandations:\n"
        "- Consultation médicale recommandée\n"
        "- Traitement antibiotique potentiellement nécessaire\n\n"
        "Notes supplémentaires:\n"
        "Cette analyse a été effectuée avec le modèle v2.3";

    setState(() {
      _isAnalyzing = false;
    });
  }
}

// Widget pour créer une bordure en pointillés améliorée
class DashedBorder extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color color;
  final List<double> dashPattern;

  const DashedBorder({
    Key? key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 8.0,
    this.color = Colors.grey,
    this.dashPattern = const [5, 5],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: CustomPaint(
        painter: DashBorderPainter(
          color: color,
          borderRadius: borderRadius,
          dashPattern: dashPattern,
        ),
        child: child,
      ),
    );
  }
}

class DashBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final List<double> dashPattern;

  DashBorderPainter({
    this.color = Colors.grey,
    this.borderRadius = 8.0,
    this.dashPattern = const [5, 5],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dashWidth = dashPattern[0];
    final dashSpace = dashPattern[1];

    // Top line
    double startX = borderRadius;
    final double endX = size.width - borderRadius;
    while (startX < endX) {
      final double segmentEnd = startX + dashWidth < endX ? startX + dashWidth : endX;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(segmentEnd, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right line
    double startY = borderRadius;
    final double endY = size.height - borderRadius;
    while (startY < endY) {
      final double segmentEnd = startY + dashWidth < endY ? startY + dashWidth : endY;
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, segmentEnd),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom line
    startX = size.width - borderRadius;
    while (startX > borderRadius) {
      final double segmentEnd = startX - dashWidth > borderRadius ? startX - dashWidth : borderRadius;
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(segmentEnd, size.height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    // Left line
    startY = size.height - borderRadius;
    while (startY > borderRadius) {
      final double segmentEnd = startY - dashWidth > borderRadius ? startY - dashWidth : borderRadius;
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, segmentEnd),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashBorderPainter oldDelegate) => 
      color != oldDelegate.color || 
      borderRadius != oldDelegate.borderRadius ||
      dashPattern != oldDelegate.dashPattern;
}