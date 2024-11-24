import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meow_hack_app/features/schedule/shedule_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/lesson_model.dart';
import '../features/account/account_api.dart';
import '../features/grade/grade_api.dart';

class GlobalDataProvider extends ChangeNotifier {
  List<LessonModel> lessons = [];
  Map<String, List<int>> grades = {};
  double gpa = 0.0;
  double percentile = 0.0;
  Map<String, dynamic> userInfo = {};
  bool isLoading = true;

  Future<void> fetchInitialData(BuildContext context) async {
    try {
      lessons = await _loadScheduleFromCache();
      notifyListeners();

      final List<dynamic> fetchedData = await Future.wait([
        fetchLessons(context),
        fetchGrades(context),
        fetchGPA(context),
        fetchPercentile(context),
        fetchUserInfo(context),
      ]);

      lessons = fetchedData[0] as List<LessonModel>;
      grades = fetchedData[1] as Map<String, List<int>>;
      gpa = fetchedData[2] as double;
      percentile = fetchedData[3] as double;
      userInfo = fetchedData[4] as Map<String, dynamic>;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching initial data: $e");
      isLoading = false;
      notifyListeners();
    }
  }


  Future<List<LessonModel>> _loadScheduleFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('schedule_cache');
    if (cachedData != null) {
      final List<dynamic> jsonList = jsonDecode(cachedData);
      return jsonList.map((json) => LessonModel.fromJson(json)).toList();
    }
    return [];
  }


  Future<List<LessonModel>> fetchLessons(BuildContext context) async {
    final api = ScheduleApi(context);
    try {
      final lessons = await api.fetchSchedule();
      return lessons.map((lesson) => LessonModel.fromJson(lesson)).toList();
    } catch (e) {
      print("Error fetching lessons: $e");
      return [];
    }
  }

  Future<Map<String, List<int>>> fetchGrades(BuildContext context) async {
    try {
      final api = GradeApi(context);
      return api.fetchGrades(); // Замените заглушку реальным запросом
    } catch (e) {
      print("Error fetching grades: $e");
      return {};
    }
  }

  Future<double> fetchGPA(BuildContext context) async {
    try {
      final api = GradeApi(context);
      return api.fetchGPA();; // Замените заглушку реальным запросом
    } catch (e) {
      print("Error fetching GPA: $e");
      return 0.0;
    }
  }

  Future<double> fetchPercentile(BuildContext context) async {
    try {
      final api = GradeApi(context);
      return api.fetchPercentile(); // Замените заглушку реальным запросом
    } catch (e) {
      print("Error fetching percentile: $e");
      return 0.0;
    }
  }

  Future<Map<String, dynamic>> fetchUserInfo(BuildContext context) async {
    try {
      final api = AccountApi(context);
      return await api.fetchUserInfo();
    } catch (e) {
      print("Error fetching user info: $e");
      return {};
    }
  }
}
