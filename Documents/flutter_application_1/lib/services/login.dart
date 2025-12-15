import 'dio.dart';
import 'connectivity.dart';

class LoginService {
  final dio = DioClient().dio;

  Future<ApiResponse<dynamic>> login(String identifiant, String motDePasse) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'identifiant': identifiant, 'mot_de_passe': motDePasse},
      );

      return ApiResponse<dynamic>.fromJson(response.data, (_) => null);
    } catch (e) {
      throw e;
    }
  }

  Future<ApiResponse<void>> forgotPassword(String email, String phone) async {
    try {
      final response = await dio.post(
        '/auth/forget_password',
        data: {'email': email, 'identifiant': phone},
      );

      return ApiResponse<dynamic>.fromJson(response.data, (_) => null);
    } catch (e) {
      throw e;
    }
  }
}
