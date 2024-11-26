import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/settings/app_settings.dart';

class EntranceApi {
  final BuildContext context;
  final Dio _dio = Dio();

  EntranceApi(this.context) {
    // Настройка Dio (например, можно добавить интерсепторы)
    _dio.options.baseUrl = 'https://meowhacks.efbo.ru';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  String? _getAccessToken() {
    final settings = Provider.of<AppSettings>(context, listen: false);
    return settings.accessToken;
  }

  Future<List<dynamic>> fetchEntranceHistory() async {
    final token = _getAccessToken();
    if (token == null) {
      throw Exception('Отсутствует токен доступа.');
    }

    try {
      final response = await _dio.get(
        '/api/users/neutral/entrances',
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['history'] as List<dynamic>;
      } else {
        throw Exception('Ошибка: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка загрузки истории: $e');
    }
  }
}
