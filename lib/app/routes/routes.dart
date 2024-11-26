import 'package:flutter/material.dart';
import 'package:meow_hack_app/features/account/account_screen.dart';
import 'package:meow_hack_app/features/schedule/schedule_screen.dart';
import 'package:meow_hack_app/features/test/refresh_token_test.dart';
import 'package:meow_hack_app/features/test/test.dart';

import '../../features/entrance/entrance_screen.dart';
import '../../features/grade/grade_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/students/students_screen.dart';
import '../app_runner.dart';

class PageRouter {
  final Env env;
  final String role; // Добавляем роль

  PageRouter(this.env, this.role);

  List<Widget> get pages {
    switch (env) {
      case Env.dev:
        if (role == 'teacher') {
          return [
            Center(child: LessonSchedulePage()), // Преподавательские страницы
            Center(child: StudentsScreen()),
            Center(child: EntranceHistoryPage()),
            Center(child: SettingsScreen()),
          ];
        } else if (role == 'student') {
          return [
            Center(child: LessonSchedulePage()), // Студенческие страницы
            Center(child: GradeScreen()),
            Center(child: EntranceHistoryPage()),
            Center(child: SettingsScreen()),
          ];
        }
        break;
      case Env.prod:
        if (role == 'teacher') {
          return [
            Center(child: Placeholder()),
            Center(child: Placeholder()),
            Center(child: Placeholder()),
            Center(child: Placeholder()),
          ];
        } else if (role == 'student') {
          return [
            Center(child: Placeholder()),
            Center(child: Placeholder()),
            Center(child: Placeholder()),
          ];
        }
        break;
      case Env.test:
        if (role == 'teacher') {
          return [
            Center(child: Test()),
            Center(child: TokenInterceptorTestPage()),
            Center(child: Placeholder()),
            Center(child: AccountScreen()),
          ];
        } else if (role == 'student') {
          return [
            Center(child: Test()),
            Center(child: Placeholder()),
            Center(child: Placeholder()),
          ];
        }
        break;
      default:
        return [
          Center(child: Placeholder()),
          Center(child: Placeholder()),
          Center(child: Placeholder()),
          Center(child: Placeholder()),
        ];
    }
    return [Center(child: Placeholder())];
  }

  int get length => (pages).length;
}



