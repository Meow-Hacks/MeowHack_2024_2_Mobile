import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/settings/app_settings.dart';

class GradeApi {
  final BuildContext context;

  GradeApi(this.context);

  Dio _getAuthorizedDio() {
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    final dio = Dio();
    dio.options.headers['Authorization'] = '${appSettings.accessToken}';
    return dio;
  }

  Future<Map<String, List<int>>> fetchGrades() async {
    final dio = _getAuthorizedDio();
    try {
      final response = await dio.get('https://meowhacks.efbo.ru/api/users/student/grade');
      final Map<String, dynamic> rawSubjects = Map<String, dynamic>.from(response.data['subjects']);

      // Приводим элементы списков к типу int
      final Map<String, List<int>> grades = rawSubjects.map((key, value) {
        return MapEntry(key, List<int>.from(value.map((e) => e as int)));
      });

      return grades;
    } catch (e) {
      throw Exception('Failed to fetch grades: $e');
    }
  }


  Future<double> fetchGPA() async {
    final dio = _getAuthorizedDio();
    try {
      final response = await dio.get('https://meowhacks.efbo.ru/api/users/student/gpa');
      return response.data['gpa'] as double;
    } catch (e) {
      throw Exception('Failed to fetch GPA: $e');
    }
  }

  Future<double> fetchPercentile() async {
    final dio = _getAuthorizedDio();
    try {
      final response = await dio.get('https://meowhacks.efbo.ru/api/users/student/percentile');
      return response.data['percentile'] as double;
    } catch (e) {
      throw Exception('Failed to fetch percentile: $e');
    }
  }
}
