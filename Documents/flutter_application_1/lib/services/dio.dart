// lib/services/dio_client.dart
import 'package:beamer/beamer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/apiResponse.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late Dio dio;
  
  // Stocker le BuildContext global
  static BuildContext? _globalContext;
  
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

  // Méthode pour initialiser le context
  static void setContext(BuildContext context) {
    _globalContext = context;
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
            // Nettoyer le token
            localStorage.removeItem('token');
            
            // Rediriger vers la page de connexion
            _redirectToLogin();
            
            print("🔒 Session expirée, redirection vers login");
          }
          return handler.next(e);
        },
      ),
    );
  }

  void _redirectToLogin() {
    if (_globalContext != null) {
      // Utiliser Beamer avec le context global
      Beamer.of(_globalContext!, root: true).beamToNamed('/login');
    } else {
      print("⚠️ Context non initialisé, impossible de rediriger");
    }
  }

  // Reste du code inchangé...
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

      return ApiResponse.fromJson(response.data, fromJsonT);
    } on DioException catch (e) {
      if (e.response != null) {
        try {
          return ApiResponse.fromJson(
            e.response!.data,
            (json) => json as T,
          );
        } catch (_) {
          throw Exception('Erreur lors du parsing de la réponse: ${e.message}');
        }
      } else {
        throw Exception(_getDioErrorMessage(e));
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  String _getDioErrorMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Timeout : Impossible de se connecter au serveur.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Pas de connexion Internet ou erreur réseau.';
    } else {
      return 'Erreur : ${e.message}';
    }
  }

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