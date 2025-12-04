import 'package:localstorage/localstorage.dart';
import 'dio.dart';

class LoginService {
  final dio = DioClient().dio;

  Future<bool> login(String identifiant, String mot_de_passe) async {
    print(identifiant);
    print(mot_de_passe);
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'identifiant': identifiant,
          'mot_de_passe': mot_de_passe,
        },
      );
      print('✅ Login successful: ${response.data}');
      final token = response.data['data']['access_token'];

      if (token != null) {
        localStorage.setItem('token', token);
        print("🔑 Token saved: $token");
        return true;
      }

      return false;
    } catch (e) {
      print('❌ Login failed: $e');
      return false;
    }
  }
}
