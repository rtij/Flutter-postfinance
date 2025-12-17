import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/comptes.dart';
import 'package:flutter_application_1/services/compteService.dart';
import 'package:flutter_application_1/screens/Client-space/account/bankAccountCard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<CardAccount> comptes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getComptes();
  }

  Future<void> _getComptes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await CompteService().getComptes();

      if (response.code == 200) {
        // DEBUG: Afficher les données brutes
        print("📦 Données brutes de l'API: ${response.data}");
        
        // Convertir les données en liste de CardAccount
        final dynamic rawData = response.data;
        List<dynamic> comptesData = [];

        if (rawData is List) {
          comptesData = rawData;
        } else if (rawData is Map) {
          comptesData = rawData['comptes'] ?? 
                        rawData['data'] ?? 
                        rawData['accounts'] ?? 
                        [];
        }

        setState(() {
          comptes = comptesData
              .map((compteJson) {
                try {
                  return CardAccount.fromJson(compteJson);
                } catch (e) {
                  print("❌ Erreur de conversion pour: $compteJson");
                  print("❌ Erreur: $e");
                  rethrow;
                }
              })
              .toList();
          isLoading = false;
        });

        print("✅ ${comptes.length} compte(s) chargé(s)");
      } else {
        setState(() {
          isLoading = false;
          errorMessage = response.msg ?? "Erreur lors du chargement des comptes";
        });

        if (mounted) {
          print(response.code);
          print(response.msg);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur: ${response.msg}"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      setState(() {
        isLoading = false;
        errorMessage = "Erreur de connexion";
      });

      print("❌ Erreur de requête: $error");
      print("❌ Stack trace: $stackTrace");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur: ${error.toString()}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _getComptes,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mes comptes',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1f2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${comptes.length} compte${comptes.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.white.withOpacity(0.6)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    if (!isLoading)
                      IconButton(
                        onPressed: _getComptes,
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Contenu
            if (isLoading)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chargement de vos comptes...',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (errorMessage != null)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _getComptes,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              )
            else if (comptes.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 64,
                        color: isDark
                            ? Colors.white.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun compte disponible',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              // Carrousel horizontal
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 385,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.92),
                    itemCount: comptes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: BankAccountCard(
                          compte: comptes[index],
                          isDarkMode: isDark,
                          onTap: () {
                            print('Compte sélectionné: ${comptes[index].numcompte}');
                            // Navigation vers les détails
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Autres sections
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Transactions récentes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1f2937),
                  ),
                ),
              ),
            ),
            
            // TODO: Ajouter la liste des transactions
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'Aucune transaction récente',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.5)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}