import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meow_hack_app/app/settings/app_settings.dart';
import 'package:provider/provider.dart';

class AccountApi {
  final BuildContext context;

  AccountApi(this.context);

  Future<Map<String, dynamic>> fetchUserInfo() async {
    final appSettings = Provider.of<AppSettings>(context, listen: false);

    try {
      final response = await Dio().get(
        'https://meowhacks.efbo.ru/api/users/student/info',
        options: Options(headers: {
          'Authorization': appSettings.accessToken,
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch user info');
      }
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }
}
