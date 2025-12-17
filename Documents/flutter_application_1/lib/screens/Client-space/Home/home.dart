import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_application_1/shared/animatedBackground.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/login.dart';
import 'package:flutter_application_1/providers/themeProvider.dart';

class MenuItem {
  final String link;
  final String label;
  final String? badge;
  final IconData? icon;

  MenuItem({required this.link, required this.label, this.badge, this.icon});
}

class MenuSection {
  final String title;
  final IconData icon;
  bool collapsed;
  final List<MenuItem>? items;
  final String? link;

  MenuSection({
    required this.title,
    required this.icon,
    this.collapsed = true,
    this.items,
    this.link,
  });
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final LoginService _loginService = LoginService();
  Map<String, dynamic>? currentUser;
  bool isLoadingUser = true;
  late List<MenuSection> menuSections;
  bool isDarkMode = false;

  @override
  void initState() {
    isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    super.initState();
    _initializeMenuSections();
    loadCurrentUser();
    _loadThemePreference();
  }

  void _loadThemePreference() {
    final theme = localStorage.getItem('theme');
    setState(() {
      isDarkMode = theme == 'dark';
    });
  }

  void _toggleTheme(bool value) {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void loadCurrentUser() async {
    try {
      await _loginService
          .getCurrentUser()
          .then((res) {
            if (res.code == 200) {
              setState(() {
                currentUser = res.data['info_user'];
                isLoadingUser = false;
              });
            } else {
              setState(() {
                isLoadingUser = false;
              });
            }
          })
          .catchError((err) {
            setState(() {
              isLoadingUser = false;
            });
          });
    } catch (e) {
      setState(() {
        isLoadingUser = false;
      });
    }
  }

  void _initializeMenuSections() {
    menuSections = [
      MenuSection(
        title: 'Accueil',
        icon: Icons.home_rounded,
        link: '/home/accueil',
        collapsed: true,
      ),
      MenuSection(
        title: 'Gestion de compte',
        icon: Icons.account_balance_wallet_rounded,
        collapsed: true,
        items: [
          MenuItem(
            link: '/home/gestion-compte/mes-comptes',
            label: 'Mes comptes',
            icon: Icons.chevron_right,
          ),
          MenuItem(
            link: '/home/gestion-compte/historique-transaction',
            label: 'Historique des transactions',
            icon: Icons.chevron_right,
          ),
        ],
      ),
      MenuSection(
        title: 'Gestion des bénéficiaires',
        icon: Icons.people_rounded,
        collapsed: true,
        items: [
          MenuItem(
            link: '/home/nouveau-beneficiaire',
            label: 'Nouveau bénéficiaire',
            icon: Icons.chevron_right,
          ),
          MenuItem(
            link: '/home/mes-beneficiaires',
            label: 'Mes bénéficiaires',
            icon: Icons.chevron_right,
          ),
        ],
      ),
      MenuSection(
        title: 'Virements',
        icon: Icons.swap_horiz_rounded,
        collapsed: true,
        items: [
          MenuItem(
            link: '/home/gestion-virement/nouveau-virement',
            label: 'Nouveau virement',
            icon: Icons.chevron_right,
          ),
          MenuItem(
            link: '/home/gestion-virement/listes',
            label: 'Mes virements',
            icon: Icons.chevron_right,
          ),
        ],
      ),
      MenuSection(
        title: 'Gestion des demandes',
        icon: Icons.task_rounded,
        collapsed: true,
        items: [
          MenuItem(
            link: '/home/demande/avance-salaire',
            label: 'Avance sur salaire',
            icon: Icons.chevron_right,
          ),
          MenuItem(
            link: '/home/demande/attestation',
            label: 'Attestation',
            icon: Icons.chevron_right,
          ),
          MenuItem(
            link: '/home/demande/commande-chequier',
            label: 'Commande de chéquier',
            icon: Icons.chevron_right,
          ),
          MenuItem(
            link: '/home/demande/autre-demande',
            label: 'Autres demandes',
            icon: Icons.chevron_right,
          ),
        ],
      ),
      MenuSection(
        title: 'Transfert',
        icon: Icons.attach_money_rounded,
        collapsed: true,
        items: [
          MenuItem(
            link: '/home/gestion-transfert/transfert-cash',
            label: 'Transfert cash',
            icon: Icons.chevron_right,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      showThemeSwitcher: false,
      showPageIndicators: false,
      contentPadding: EdgeInsets.zero,
      content: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: _buildModernDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'POSTE FINANCE',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu_rounded),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        body: Beamer(routerDelegate: homeRouterDelegate),
      ),
    );
  }

  Widget _buildModernDrawer() {
    return Drawer(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFF5F7FA), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header moderne avec bouton de fermeture
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Profile Section moderne
              _buildModernProfile(),

              const SizedBox(height: 24),

              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ...menuSections.map(
                      (section) => _buildModernMenuSection(section),
                    ),

                    // Theme Switcher à la fin
                    const SizedBox(height: 8),
                    _buildThemeSwitcher(),
                  ],
                ),
              ),

              // Footer avec déconnexion
              _buildModernFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitcher() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1F2937) : Colors.amber[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 20,
              color: isDarkMode ? Colors.white : Colors.amber[700],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isDarkMode ? 'Mode sombre' : 'Mode clair',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: isDarkMode,
              onChanged: _toggleTheme,
              activeColor: Theme.of(context).primaryColor,
              activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernProfile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: isLoadingUser
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : Text(
                      _getInitials(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoadingUser
                      ? 'Chargement...'
                      : '${currentUser?['prenom'] ?? ''} ${currentUser?['nom'] ?? ''}'
                            .trim(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  isLoadingUser ? '' : currentUser?['email'] ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernMenuSection(MenuSection section) {
    // Si c'est un lien simple sans sous-items
    if (section.link != null &&
        (section.items == null || section.items!.isEmpty)) {
      return _buildModernSimpleMenuItem(section);
    }

    // Si c'est une section avec des sous-items
    final isExpanded = !section.collapsed;
    final isActive = _isAnySectionItemActive(section);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  section.collapsed = !section.collapsed;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).primaryColor.withOpacity(0.15)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        section.icon,
                        size: 20,
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        section.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isActive
                              ? Theme.of(context).primaryColor
                              : const Color(0xFF374151),
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Container(
                    margin: const EdgeInsets.only(left: 16, top: 4),
                    child: _buildModernSubItems(section),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSimpleMenuItem(MenuSection section) {
    final isActive = _isCurrentPath(section.link!);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pop(context);
            context.beamToNamed(section.link!);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).primaryColor.withOpacity(0.15)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    section.icon,
                    size: 20,
                    color: isActive
                        ? Theme.of(context).primaryColor
                        : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? Theme.of(context).primaryColor
                          : const Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSubItems(MenuSection section) {
    return Column(
      children: section.items!.map((item) {
        final isActive = _isCurrentPath(item.link);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pop(context);
              context.beamToNamed(item.link);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).primaryColor.withOpacity(0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Theme.of(context).primaryColor
                          : const Color(0xFFD1D5DB),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  if (item.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModernFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _handleLogout,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Déconnexion',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isAnySectionItemActive(MenuSection section) {
    if (section.items == null || section.items!.isEmpty) {
      return section.link != null && _isCurrentPath(section.link!);
    }
    return section.items!.any((item) => _isCurrentPath(item.link));
  }

  String _getInitials() {
    if (currentUser == null) return 'U';

    final prenom = currentUser?['prenom']?.toString() ?? '';
    final nom = currentUser?['nom']?.toString() ?? '';

    if (prenom.isNotEmpty && nom.isNotEmpty) {
      return '${prenom[0]}${nom[0]}'.toUpperCase();
    } else if (nom.isNotEmpty) {
      return nom[0].toUpperCase();
    }

    return 'U';
  }

  void _handleLogout() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    context.beamToNamed('/login');
  }

  bool _isCurrentPath(String path) {
    final currentPath =
        (context.currentBeamLocation.state as BeamState).uri.path;
    return currentPath == path || currentPath.startsWith('$path/');
  }
}
