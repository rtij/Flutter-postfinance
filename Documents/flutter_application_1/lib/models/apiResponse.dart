// lib/models/api_response.dart
class ApiResponse<T> {
  final String status;
  final T data;
  final int code;
  final String reason;
  final String msg;
  final bool error;
  final String errorCode;

  ApiResponse({
    required this.status,
    required this.data,
    required this.code,
    required this.reason,
    required this.msg,
    required this.error,
    required this.errorCode,
  });

  // Méthode pour créer une ApiResponse depuis un Map (JSON)
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      status: json['status'] ?? '',
      data: fromJsonT(json['data']),
      code: json['code'] ?? 0,
      reason: json['reason'] ?? '',
      msg: json['msg'] ?? '',
      error: json['error'] ?? false,
      errorCode: json['errorCode'] ?? '',
    );
  }
}
