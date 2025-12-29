import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/beneficiaire.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'package:flutter_application_1/services/beneficiaire.dart';

class BeneficiairesListScreen extends StatefulWidget {
  const BeneficiairesListScreen({super.key});

  @override
  State<BeneficiairesListScreen> createState() =>
      _BeneficiairesListScreenState();
}

class _BeneficiairesListScreenState extends State<BeneficiairesListScreen> {
  final BeneficiaireService _service = BeneficiaireService();

  List<Beneficiaire> beneficiaires = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBeneficiaires();
  }

  Future<void> _loadBeneficiaires() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final res = await _service.getAllBeneficiaires();

      if (res.code == 200) {
        print("✅ Données bénéficiaires reçues: ${res.data}");
        final List<dynamic> dataList = res.data ?? [];
        final List<Beneficiaire> loadedBeneficiaires = dataList
            .map((data) => Beneficiaire.fromJson(data))
            .toList();

        setState(() {
          beneficiaires = loadedBeneficiaires;
          isLoading = false;
        });
        
        print("✅ ${beneficiaires.length} bénéficiaire(s) chargé(s)");
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              res.msg;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur: ${res.msg}"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = "Erreur de connexion";
      });

      print("❌ Erreur de requête: $error");

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

  Future<void> _refresh() async {
    await _loadBeneficiaires();
  }

  void _supprimerBeneficiaire(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Supprimer ce bénéficiaire ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                beneficiaires.removeWhere((b) => b.id == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bénéficiaire supprimé')),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  String _initiales(Beneficiaire b) =>
      '${b.nom.isNotEmpty ? b.nom[0] : ''}${b.prenom.isNotEmpty ? b.prenom[0] : ''}'
          .toUpperCase();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          homeRouterDelegate.beamToNamed('/home/nouveau-beneficiaire');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildHeader(isDark),

            if (isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (errorMessage != null)
              _buildError(errorMessage!)
            else if (beneficiaires.isEmpty)
              _buildEmpty(isDark)
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildCard(beneficiaires[index], isDark),
                    childCount: beneficiaires.length,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(bool isDark) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mes Bénéficiaires',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1f2937),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${beneficiaires.length} bénéficiaire(s)',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? Colors.white.withOpacity(0.6)
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverFillRemaining _buildError(String message) {
    return SliverFillRemaining(
      child: Center(
        child: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  SliverFillRemaining _buildEmpty(bool isDark) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: isDark
                  ? Colors.white.withOpacity(0.3)
                  : const Color(0xFFD1D5DB),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun bénéficiaire',
              style: TextStyle(
                fontSize: 18,
                color: isDark
                    ? Colors.white.withOpacity(0.7)
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Beneficiaire b, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1f2937).withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                _initiales(b),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${b.nom} ${b.prenom}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1f2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    b.numCompte ?? '-',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () => Future.delayed(
                    Duration.zero,
                    () => _supprimerBeneficiaire(b.id),
                  ),
                  child: const Text('Supprimer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
