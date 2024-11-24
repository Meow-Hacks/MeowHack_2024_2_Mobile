import 'package:flutter/material.dart';
import 'package:meow_hack_app/features/account/account_screen.dart';
import 'package:meow_hack_app/features/schedule/schedule_screen.dart';
import 'package:meow_hack_app/features/test/refresh_token_test.dart';
import 'package:meow_hack_app/features/test/test.dart';

import '../../features/grade/grade_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../app_runner.dart';

class PageRouter {
  final Env env;

  PageRouter(this.env);

  Future<List<Widget>> get pages async {
    switch (env) {
      case Env.dev:
        return [
          Center(child: Test()),
          Center(child: LessonSchedulePage()),
          Center(child: GradeScreen()),
          Center(child: SettingsScreen()),
        ];
      case Env.prod:
        return [
          Center(child: Placeholder()),
          Center(child: Placeholder()),
          Center(child: Placeholder()),
          Center(child: Placeholder()), // Укажите здесь реальные страницы
        ];
      case Env.test:
        return [
          Center(child: Test()),
          Center(child: TokenInterceptorTestPage()),
          Center(child: Placeholder()),
          Center(child: AccountScreen()),
        ];
      default:
        return [
          Center(child: Placeholder()),
          Center(child: Placeholder()),
          Center(child: Placeholder()),
          Center(child: Placeholder()),
        ];
    }
  }

  Future<int> get length async => (await pages).length;
}

