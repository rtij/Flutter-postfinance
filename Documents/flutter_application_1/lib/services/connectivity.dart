class ApiResponse<T> {
  final int code;
  final String msg;
  final bool error;
  final T data;

  ApiResponse({
    required this.code,
    required this.msg,
    required this.error,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'],
      msg: json['msg'],
      error: json['error'],
      data: json['data'],
    );
  }
}
