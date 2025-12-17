import 'dio.dart';
import 'connectivity.dart';

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
}
