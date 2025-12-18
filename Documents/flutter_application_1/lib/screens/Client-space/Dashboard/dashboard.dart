import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/comptes.dart';
import 'package:flutter_application_1/models/transaction.dart';
import 'package:flutter_application_1/services/compteService.dart';
import 'package:flutter_application_1/screens/Client-space/account/bankAccountCard.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<CardAccount> comptes = [];
  List<Transaction> recentTransactions = [];
  bool isLoading = true;
  bool isLoadingTransactions = false;
  String? errorMessage;
  int currentAccountIndex = 0;

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
        print("📦 Données brutes de l'API: ${response.data}");

        final dynamic rawData = response.data;
        List<dynamic> comptesData = [];

        if (rawData is List) {
          comptesData = rawData;
        } else if (rawData is Map) {
          comptesData =
              rawData['comptes'] ??
              rawData['data'] ??
              rawData['accounts'] ??
              [];
        }

        setState(() {
          comptes = comptesData.map((compteJson) {
            try {
              return CardAccount.fromJson(compteJson);
            } catch (e) {
              print("❌ Erreur de conversion pour: $compteJson");
              print("❌ Erreur: $e");
              rethrow;
            }
          }).toList();
          isLoading = false;
        });

        print("✅ ${comptes.length} compte(s) chargé(s)");

        // Charger les transactions du premier compte s'il existe
        if (comptes.isNotEmpty) {
          _loadTransactions(comptes[0].numcompte);
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              response.msg ?? "Erreur lors du chargement des comptes";
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

  Future<void> _loadTransactions(String numcompte) async {
    setState(() {
      isLoadingTransactions = true;
    });

    try {
      final response = await CompteService().getHistoriqueVirement(
        numcompte: numcompte,
        nombreTransactions: 8,
      );

      if (response.code == 200) {
        setState(() {
          recentTransactions = response.data.map<Transaction>((json) {
            try {
              return Transaction.fromJson(json);
            } catch (e) {
              print("❌ Erreur de conversion de transaction pour: $json");
              print("❌ Erreur: $e");
              rethrow;
            }
          }).toList();
          isLoadingTransactions = false;
        });
        print("✅ ${recentTransactions.length} transaction(s) chargée(s)");
      } else {
        setState(() {
          isLoadingTransactions = false;
          recentTransactions = [];
        });
        print("⚠️ Erreur chargement transactions: ${response.msg}");
      }
    } catch (error) {
      setState(() {
        isLoadingTransactions = false;
        recentTransactions = [];
      });
      print("❌ Erreur transactions: $error");
    }
  }

  void _onAccountChanged(int index) {
    if (currentAccountIndex != index && comptes.isNotEmpty) {
      setState(() {
        currentAccountIndex = index;
      });
      _loadTransactions(comptes[index].numcompte);
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatAmount(String montant) {
    try {
      final amount = double.parse(montant);
      final formatter = NumberFormat('#,##0', 'fr_FR');
      return formatter.format(amount);
    } catch (e) {
      return montant;
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
                        // Nombre de comptes 
                        Text(
                          '${comptes.length} compte(s) disponible(s)',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.white.withOpacity(0.7)
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
            else ...[
              // Carrousel horizontal des comptes
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.92),
                    itemCount: comptes.length,
                    onPageChanged: _onAccountChanged,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: BankAccountCard(
                          compte: comptes[index],
                          isDarkMode: isDark,
                          onTap: () {
                            print(
                              'Compte sélectionné: ${comptes[index].numcompte}',
                            );
                            // Navigation vers les détails
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Section Transactions récentes
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions récentes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1f2937),
                        ),
                      ),
                      if (isLoadingTransactions)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Liste des transactions
              if (isLoadingTransactions)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                )
              else if (recentTransactions.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: isDark
                                ? Colors.white.withOpacity(0.3)
                                : const Color(0xFF9CA3AF),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Aucune transaction récente',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final transaction = recentTransactions[index];
                      return _buildTransactionCard(transaction, isDark);
                    }, childCount: recentTransactions.length),
                  ),
                ),

              // Spacing en bas
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction, bool isDark) {
    final isCredit = transaction.sens.toUpperCase() == 'C';
    final amountColor = isCredit ? Colors.green : Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1f2937).withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date et Référence
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(transaction.dateTransaction),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 2),
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Réf: ',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? Colors.white.withOpacity(0.5)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    TextSpan(
                      text: transaction.reference,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Montant
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Montant:',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? Colors.white.withOpacity(0.7)
                      : const Color(0xFF6B7280),
                ),
              ),
              Flexible(
                child: Text(
                  '${isCredit ? '+' : '-'}${_formatAmount(transaction.montant)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
