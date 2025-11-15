class UserModel {
  final String message;
  final dynamic data;
  final int? statusCode;

  UserModel({
    required this.message,
    this.data,
    this.statusCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      message: json['message']?.toString() ?? '',
      data: json['data'],
      statusCode: json['statusCode'] is int ? json['statusCode'] as int : null,
    );
  }
}
