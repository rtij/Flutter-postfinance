// lib/services/dio_client.dart
import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import '../models/apiResponse.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late Dio dio;
  
  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://mobile-pf.sunuphco.com/",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    _addInterceptor();
  }

  void _addInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = localStorage.getItem('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            localStorage.removeItem('token');
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Méthode générique pour les requêtes avec gestion de ApiResponse
  Future<ApiResponse<T>> request<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) fromJsonT,
  }) async {
    try {
      final response = await dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      // Parse la réponse en ApiResponse<T>
      return ApiResponse.fromJson(response.data, fromJsonT);
    } on DioException catch (e) {
      // Gestion des erreurs Dio
      if (e.response != null) {
        // Si le serveur retourne une erreur structurée (ex: 400, 500)
        try {
          return ApiResponse.fromJson(
            e.response!.data,
            (json) => json as T, // Gestion basique, à adapter selon tes besoins
          );
        } catch (_) {
          throw Exception('Erreur lors du parsing de la réponse: ${e.message}');
        }
      } else {
        // Erreurs réseau (timeout, pas de connexion)
        throw Exception(_getDioErrorMessage(e));
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  // Méthode pour obtenir un message d'erreur clair
  String _getDioErrorMessage(DioException e) {
    if (e.type == DioErrorType.connectionTimeout ||
        e.type == DioErrorType.receiveTimeout ||
        e.type == DioErrorType.sendTimeout) {
      return 'Timeout : Impossible de se connecter au serveur.';
    } else if (e.type == DioErrorType.unknown) {
      return 'Pas de connexion Internet ou erreur réseau.';
    } else {
      return 'Erreur : ${e.message}';
    }
  }

  // Méthodes spécifiques pour GET, POST, etc.
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJsonT,
  }) async {
    return request(
      path,
      queryParameters: queryParameters,
      options: Options(method: 'GET'),
      fromJsonT: fromJsonT,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    required T Function(dynamic) fromJsonT,
  }) async {
    return request(
      path,
      data: data,
      options: Options(method: 'POST'),
      fromJsonT: fromJsonT,
    );
  }
}
