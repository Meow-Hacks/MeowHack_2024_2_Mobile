import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meow_hack_app/di/dependencies_manager.dart';
import 'app.dart';

enum Env { dev, prod, test }

class AppRunner {
  final Env env;

  AppRunner(this.env);

  Future<void> run() async {
    runZonedGuarded(() async {
      await _init();
      final dependencies = DependenciesManager(env);
      await dependencies.init();
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Делаем статус бар прозрачным
          statusBarIconBrightness: Brightness.dark, // Темные иконки для светлого фона
        ),
      );
      runApp(App(dependencies: dependencies, env: env,));
      // WidgetsBinding.instance.addPersistentFrameCallback((_) {
      //   WidgetsBinding.instance.allowFirstFrame();
      // });
    }, (e, st) {
      log(
        e.toString(),
        stackTrace: st,
        error: e,
      );
    });
  }

  Future<void> _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // WidgetsBinding.instance.deferFirstFrame();
  }
}
