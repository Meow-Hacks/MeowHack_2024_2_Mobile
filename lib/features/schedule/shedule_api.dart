import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/settings/app_settings.dart';

class ScheduleApi {
  final BuildContext context;
  static const String _cacheKey = 'schedule_cache';

  ScheduleApi(this.context);

  Future<List<Map<String, dynamic>>> fetchSchedule() async {
    print(1);
    const url = 'https://meowhacks.efbo.ru/api/users/student/lessons';

    try {
      // Выполняем авторизованный запрос
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'authorization': '${_getAccessToken()}',
          },
        ),
      );

      // Если запрос успешен, обновляем кэш и возвращаем данные
      if (response.statusCode == 200) {
        final lessons = List<Map<String, dynamic>>.from(response.data['lessons']);
        // print(lessons);
        await _saveScheduleToCache(lessons);
        return lessons;
      } else {
        throw Exception('Ошибка при загрузке расписания');
      }
    } catch (e) {
      // Если ошибка, проверяем кэш
      print('Error fetching schedule: $e');
      final cachedSchedule = await _loadScheduleFromCache();
      if (cachedSchedule.isNotEmpty) {
        return cachedSchedule;
      } else {
        rethrow;
      }
    }
  }

  String? _getAccessToken() {
    final settings = Provider.of<AppSettings>(context, listen: false);
    return settings.accessToken;
  }

  Future<void> _saveScheduleToCache(List<Map<String, dynamic>> schedule) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(schedule));
  }

  Future<List<Map<String, dynamic>>> _loadScheduleFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(cachedData));
    }
    return [];
  }
}
