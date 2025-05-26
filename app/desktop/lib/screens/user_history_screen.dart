import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

// Définition du type d'historique
enum HistoryType { analyzed, submitted }

class UserHistoryScreen extends StatefulWidget {
  final HistoryType historyType;

  const UserHistoryScreen({super.key, required this.historyType});

  @override
  _UserHistoryScreenState createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Données simulées pour démonstration
  // Dans une application réelle, cela viendrait d'une base de données ou d'une API
  final List<Map<String, dynamic>> _analyzedImages = [
    {
      'id': '1',
      'date': DateTime.now().subtract(Duration(days: 2)),
      'imagePath':
          '', // À remplacer par des chemins d'images réelles dans une vraie application
      'result': 'Pneumonie (87%)',
      'status': 'Terminé',
      'details':
          'Indications de pneumonie bactérienne dans le lobe inférieur droit.',
    },
    {
      'id': '2',
      'date': DateTime.now().subtract(Duration(days: 5)),
      'imagePath': '',
      'result': 'Sain (92%)',
      'status': 'Terminé',
      'details': 'Aucune indication de pathologie détectée.',
    },
    {
      'id': '3',
      'date': DateTime.now().subtract(Duration(days: 12)),
      'imagePath': '',
      'result': 'Pneumonie (76%)',
      'status': 'Terminé',
      'details': 'Possible pneumonie virale. Consultation recommandée.',
    },
  ];

  final List<Map<String, dynamic>> _submittedCases = [
    {
      'id': '1',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'images': 3,
      'diagnosis': 'Pneumonie',
      'status': 'En attente de révision',
      'priority': 'Élevée',
      'notes': 'Patient de 65 ans avec symptômes respiratoires depuis 5 jours.',
    },
    {
      'id': '2',
      'date': DateTime.now().subtract(Duration(days: 10)),
      'images': 2,
      'diagnosis': 'Sain',
      'status': 'Validé',
      'priority': 'Normale',
      'notes': 'Suivi de routine.',
    },
    {
      'id': '3',
      'date': DateTime.now().subtract(Duration(days: 15)),
      'images': 4,
      'diagnosis': 'Pneumonie',
      'status': 'Validé',
      'priority': 'Élevée',
      'notes': 'Patient de 42 ans avec antécédents d\'asthme.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Simuler le chargement des données
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simuler un délai réseau
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> _getFilteredItems(bool isAnalyzed) {
    final items = isAnalyzed ? _analyzedImages : _submittedCases;

    if (_searchQuery.isEmpty) {
      return items;
    }

    return items.where((item) {
      if (isAnalyzed) {
        return item['result'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            _formatDate(item['date']).contains(_searchQuery);
      } else {
        return item['diagnosis'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            item['status'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            _formatDate(item['date']).contains(_searchQuery);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final String pageTitle =
        widget.historyType == HistoryType.analyzed
            ? 'Images Analysées'
            : 'Cas Soumis';

    final bool isAnalyzed = widget.historyType == HistoryType.analyzed;
    final filteredItems = _getFilteredItems(isAnalyzed);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Utiliser le même CustomAppBar mais sans le bouton de retour automatique
      appBar: CustomAppBar(
        title: 'ahouefa',
        automaticallyImplyLeading: false, // Désactive le bouton retour
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec bouton retour et titre
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Material(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    pageTitle,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  tooltip: 'Actualiser',
                  onPressed: _loadData,
                ),
              ],
            ),
          ),

          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                        : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          Divider(),

          // Contenu principal
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child:
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : filteredItems.isEmpty
                      ? _buildEmptyState(isAnalyzed)
                      : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          // Utiliser une animation pour chaque élément de la liste
                          return AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Interval(
                                      (1 / filteredItems.length) * index,
                                      1.0,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                ),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0.5, 0.0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval(
                                        (1 / filteredItems.length) * index,
                                        1.0,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  ),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildHistoryItem(item, isAnalyzed),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action selon le type d'écran
          if (isAnalyzed) {
            Navigator.pushNamed(context, '/analyze');
          } else {
            Navigator.pushNamed(context, '/submit_case');
          }
        },
        child: Icon(
          isAnalyzed ? Icons.add_photo_alternate : Icons.create_new_folder,
        ),
        tooltip:
            isAnalyzed
                ? 'Analyser une nouvelle image'
                : 'Soumettre un nouveau cas',
      ),
    );
  }

  Widget _buildEmptyState(bool isAnalyzed) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAnalyzed ? Icons.image_not_supported : Icons.folder_off,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24),
          Text(
            isAnalyzed ? 'Aucune image analysée' : 'Aucun cas soumis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12),
          Text(
            isAnalyzed
                ? 'Commencez par analyser une radiographie'
                : 'Soumettez votre premier cas médical',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Navigation vers l'écran approprié
              if (isAnalyzed) {
                Navigator.pushNamed(context, '/analyze');
              } else {
                Navigator.pushNamed(context, '/submit_case');
              }
            },
            icon: Icon(
              isAnalyzed ? Icons.add_a_photo : Icons.create_new_folder,
            ),
            label: Text(
              isAnalyzed ? 'Analyser une image' : 'Soumettre un cas',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item, bool isAnalyzed) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDetailDialog(item, isAnalyzed),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isAnalyzed ? Icons.image : Icons.folder,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        _formatDateFull(item['date']),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusChip(item['status']),
                ],
              ),
              Divider(height: 24),
              if (isAnalyzed)
                ..._buildAnalyzedContent(item, isDarkMode)
              else
                ..._buildSubmittedContent(item, isDarkMode),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.visibility, size: 18),
                    label: Text('Détails'),
                    onPressed: () => _showDetailDialog(item, isAnalyzed),
                  ),
                  SizedBox(width: 8),
                  TextButton.icon(
                    icon: Icon(Icons.share, size: 18),
                    label: Text('Partager'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Fonctionnalité de partage à implémenter',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  List<Widget> _buildAnalyzedContent(
    Map<String, dynamic> item,
    bool isDarkMode,
  ) {
    return [
      Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 48,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
            ),
            SizedBox(height: 8),
            Text(
              'Radiographie pulmonaire',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16),
      Row(
        children: [
          Icon(
            item['result'].contains('Pneumonie')
                ? Icons.sick
                : Icons.health_and_safety,
            color:
                item['result'].contains('Pneumonie')
                    ? Colors.orange
                    : Colors.green,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Résultat: ${item['result']}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color:
                  item['result'].contains('Pneumonie')
                      ? Colors.orange[700]
                      : Colors.green[700],
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildSubmittedContent(
    Map<String, dynamic> item,
    bool isDarkMode,
  ) {
    return [
      Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.photo_library,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nombre d\'images: ${item['images']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    item['diagnosis'] == 'Pneumonie'
                        ? Icons.sick
                        : Icons.health_and_safety,
                    color:
                        item['diagnosis'] == 'Pneumonie'
                            ? Colors.orange
                            : Colors.green,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Diagnostic: ${item['diagnosis']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.priority_high,
                    size: 16,
                    color:
                        item['priority'] == 'Élevée'
                            ? Colors.red[400]
                            : Colors.blue[400],
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Priorité: ${item['priority']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }

  void _showDetailDialog(Map<String, dynamic> item, bool isAnalyzed) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 500,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAnalyzed ? 'Détails de l\'analyse' : 'Détails du cas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Divider(height: 24),

                // Contenu spécifique au type
                if (isAnalyzed) ...[
                  _buildDetailRow('Date', _formatDateFull(item['date'])),
                  _buildDetailRow('Résultat', item['result']),
                  _buildDetailRow('Statut', item['status']),
                  _buildDetailRow('Détails', item['details']),

                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 64,
                        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
                  ),
                ] else ...[
                  _buildDetailRow('Date', _formatDateFull(item['date'])),
                  _buildDetailRow(
                    'Nombre d\'images',
                    item['images'].toString(),
                  ),
                  _buildDetailRow('Diagnostic', item['diagnosis']),
                  _buildDetailRow('Statut', item['status']),
                  _buildDetailRow('Priorité', item['priority']),
                  _buildDetailRow('Notes', item['notes']),
                ],

                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      icon: Icon(Icons.print),
                      label: Text('Imprimer'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Fonctionnalité d\'impression à implémenter',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: Icon(Icons.download),
                      label: Text('Télécharger'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Rapport téléchargé avec succès'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateFull(DateTime date) {
    return DateFormat('d MMMM yyyy à HH:mm').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Terminé':
      case 'Validé':
        return Colors.green;
      case 'En attente de révision':
        return Colors.orange;
      case 'En cours':
        return Colors.blue;
      case 'Rejeté':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Déclencher l'animation quand l'écran est prêt
    _animationController.forward();
  }
}
