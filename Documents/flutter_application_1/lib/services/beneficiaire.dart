import 'dio.dart';
import '../models/beneficiaire.dart';
import 'connectivity.dart';

class BeneficiaireService {
  final dio = DioClient().dio;

  // GET all beneficiaires
  Future<ApiResponse<dynamic>> getAllBeneficiaires() async {
    try {
      final response = await dio.get('/espace_client/mes_beneficiaires');

      
    
      return ApiResponse<dynamic>.fromJson(response.data, (_) => null);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE beneficiaire
  Future<ApiResponse<void>> deleteBeneficiaire(int idBeneficiaire) async {
    try {
      final response = await dio.delete(
        '/espace_client/mes_beneficiaires/$idBeneficiaire',
      );

      return ApiResponse<void>.fromJson(response.data, (_) => null);
    } catch (e) {
      rethrow;
    }
  }

  // ADD beneficiaire
  Future<ApiResponse<void>> ajoutBeneficiaire(
    Map<String, dynamic> beneficiaireData,
  ) async {
    try {
      final response = await dio.post(
        '/espace_client/mes_beneficiaires',
        data: beneficiaireData,
      );

      return ApiResponse<void>.fromJson(response.data, (_) => null);
    } catch (e) {
      rethrow;
    }
  }
}
