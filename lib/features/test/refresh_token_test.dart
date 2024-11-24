import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../../app/settings/app_settings.dart';
import '../../../features/login/login_api.dart';

class TokenInterceptorTestPage extends StatelessWidget {
  const TokenInterceptorTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TokenInterceptor Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _testTokenInterceptor(context),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Test API Request'),
        ),
      ),
    );
  }

  Future<void> _testTokenInterceptor(BuildContext context) async {
    final dio = Dio();
    dio.interceptors.add(TokenInterceptor(context));

    try {
      // Выполняем тестовый запрос
      final response = await dio.get('https://meowhacks.efbo.ru/api/users/student/lessons');

      // Показываем результат запроса
      _showMessage(context, 'Request successful: ${response.data}');
    } catch (e) {
      // Показываем ошибку
      _showMessage(context, 'Request failed: $e');
    }
  }

  void _showMessage(BuildContext context, String message) {
    print(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
