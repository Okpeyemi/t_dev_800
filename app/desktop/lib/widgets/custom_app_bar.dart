import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/user_history_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabBar? bottom;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.medical_information,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: isDarkMode 
          ? Colors.grey[900] 
          : Colors.white,
      shape: Border(
        bottom: BorderSide(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      actions: [
        // Bouton de thème avec animation
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isDarkMode 
                ? Colors.grey[800] 
                : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey<bool>(themeProvider.isDarkMode),
                color: themeProvider.isDarkMode ? Colors.yellow : Colors.blue[800],
              ),
            ),
            tooltip: themeProvider.isDarkMode ? 'Passer en mode clair' : 'Passer en mode sombre',
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ),
        SizedBox(width: 8),
        // Profil utilisateur
        Container(
          margin: EdgeInsets.only(right: 16),
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width > 600) // Afficher le nom uniquement sur les écrans plus larges
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    authProvider.username,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                    ),
                  ),
                ),
              PopupMenuButton<String>(
                offset: Offset(0, 45),
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: Text(
                      authProvider.username.isNotEmpty 
                        ? authProvider.username[0].toUpperCase() 
                        : 'U',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                elevation: 4,
                onSelected: (value) {
                  if (value == 'analyzed_images') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserHistoryScreen(
                          historyType: HistoryType.analyzed,
                        ),
                      ),
                    );
                  } else if (value == 'submitted_cases') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserHistoryScreen(
                          historyType: HistoryType.submitted,
                        ),
                      ),
                    );
                  } else if (value == 'logout') {
                    authProvider.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'analyzed_images',
                    child: _buildMenuItem(
                      context,
                      Icons.photo_library,
                      'Images analysées',
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'submitted_cases',
                    child: _buildMenuItem(
                      context,
                      Icons.folder_shared,
                      'Cas soumis',
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: _buildMenuItem(
                      context,
                      Icons.person,
                      'Profil',
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: _buildMenuItem(
                      context,
                      Icons.logout,
                      'Déconnexion',
                      isDestructive: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      bottom: bottom != null 
          ? PreferredSize(
              preferredSize: Size.fromHeight(50), 
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                child: bottom,
              ),
            )
          : null,
    );
  }
  
  Widget _buildMenuItem(BuildContext context, IconData icon, String text, {bool isDestructive = false}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.1)
                : Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive
                ? Colors.red
                : Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDestructive
                ? Colors.red
                : isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom != null ? 100.0 : 56.0);
}