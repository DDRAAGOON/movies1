import 'PostApi.dart';
import 'user_model.dart';

class AuthService {
  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final res = await PostApi.post(
      'auth/login',
      {
        'email': email,
        'password': password,
      },
    );
    return UserModel.fromJson(res);
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required int avaterId,
  }) async {
    final res = await PostApi.post(
      'auth/register',
      {
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'phone': phone,
        'avaterId': avaterId,
      },
    );
    return UserModel.fromJson(res);
  }

  static Future<UserModel> sendResetEmail({
    required String email,
  }) async {
    final res = await PostApi.post(
      'auth/forgot-password',
      {
        'email': email,
      },
    );
    return UserModel.fromJson(res);
  }

  static Future<UserModel> resetPassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    final res = await PostApi.patch(
      'auth/reset-password',
      {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );

    return UserModel.fromJson(res);
  }

  static Future<Map<String, dynamic>> getMovies() {
    return PostApi.get('getAllMovies');
  }
}
