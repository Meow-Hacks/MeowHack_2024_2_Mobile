import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meow_hack_app/app/settings/app_settings.dart';
import 'package:provider/provider.dart';

class LoginApi {
  late final Dio _dio;

  LoginApi(BuildContext context) {
    _dio = Dio()..interceptors.add(TokenInterceptor(context));
  }

  Future<Map<String, dynamic>> studentLogin({
    required String email,
    required String password,
  }) async {
    const url = 'https://meowhacks.efbo.ru/api/auth/student/login';

    final response = await _dio.post(url, data: {
      "mail": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Login failed: ${response.statusMessage}');
    }
  }

  Future<Map<String, dynamic>> teacherLogin({
    required String email,
    required String password,
  }) async {
    const url = 'https://meowhacks.efbo.ru/api/auth/teacher/login';

    final response = await _dio.post(url, data: {
      "mail": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Login failed: ${response.statusMessage}');
    }
  }
}


class TokenInterceptor extends Interceptor {
  final BuildContext context;

  TokenInterceptor(this.context);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final appSettings = Provider.of<AppSettings>(context, listen: false);

    // Проверяем токен перед выполнением запроса
    if (!appSettings.isAccessTokenValid() && appSettings.refreshToken != null) {
      await _refreshAccessToken(appSettings);
    }

    // Добавляем токен в заголовки запроса
    if (appSettings.accessToken != null) {
      options.headers['authorization'] = '${appSettings.accessToken}';
    }

    super.onRequest(options, handler);
  }

  Future<void> _refreshAccessToken(AppSettings appSettings) async {
    try {
      final response = await Dio().get(
        'https://meowhacks.efbo.ru/api/auth/student/refresh',
        options: Options(headers: {
          'Authorization': appSettings.refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        await appSettings.setTokens(
          response.data['access_token'],
          response.data['refresh_token'],
          DateTime.now().add(const Duration(hours: 1)),
        );
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      await appSettings.clearTokens();
      rethrow;
    }
  }
}
