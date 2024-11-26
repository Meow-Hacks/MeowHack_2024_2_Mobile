import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/settings/app_settings.dart';

class StudentsApi {
  final BuildContext context;

  StudentsApi(this.context);

  String? _getAccessToken() {
    final settings = Provider.of<AppSettings>(context, listen: false);
    return settings.accessToken;
  }

  Future<Map<String, Map<String, List<Map<String, dynamic>>>>> fetchGrades() async {
    const url = 'https://meowhacks.efbo.ru/api/users/teacher/all/grades';
    final dio = Dio();

    // Получение токена
    final settings = Provider.of<AppSettings>(context, listen: false);
    final accessToken = settings.accessToken;

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': '$accessToken', // Добавляем авторизацию
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);

        // Проверка структуры данных и преобразование
        return data.map((subject, groups) {
          final Map<String, dynamic> groupsMap = Map<String, dynamic>.from(groups);
          return MapEntry(
            subject,
            groupsMap.map((group, students) {
              final List<dynamic> studentsList = students as List<dynamic>;
              return MapEntry(
                group,
                studentsList.map((student) {
                  if (student is Map<String, dynamic>) {
                    return student;
                  } else {
                    throw Exception(
                        'Invalid student format: ${student.runtimeType}');
                  }
                }).toList(),
              );
            }),
          );
        });
      } else {
        throw Exception('Ошибка: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка загрузки данных: $e');
    }
  }



  Future<void> submitMark(int studentId, int lessonId, int mark) async {
    const url = 'https://meowhacks.efbo.ru/api/users/teacher/mark';
    try {
      final dio = Dio();
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': _getAccessToken(),
          },
        ),
        data: {
          "student_id": studentId,
          "lesson_id": lessonId,
          "mark": mark,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка при отправке оценки');
      }
    } catch (e) {
      throw Exception('Ошибка отправки оценки: $e');
    }
  }
}
