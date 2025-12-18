import 'dio.dart';
import 'connectivity.dart';
import 'package:flutter_application_1/models/transaction.dart';

class CompteService {
  final dio = DioClient().dio;

  // get liste compte
  Future<ApiResponse<dynamic>> getComptes() async {
    try {
      final response = await dio.get('/demande/comptes');

      return ApiResponse<dynamic>.fromJson(response.data, (_) => null);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<dynamic>> getHistoriqueVirement({
    required String numcompte,
    required int nombreTransactions,
  }) async {
    final response = await dio.post(
      '/espace_client/virement/historique_compte',
      data: {'numcompte': numcompte, 'nombre_transactions': nombreTransactions},
    );

    return ApiResponse<dynamic>.fromJson(response.data, (_) => null);
  }
}
