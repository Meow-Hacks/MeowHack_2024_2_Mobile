import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:meow_hack_app/di/dependencies_provider.dart';
import 'package:meow_hack_app/di/dependencies_manager.dart';
import 'package:meow_hack_app/di/overlay_manager.dart';

import 'package:meow_hack_app/app/routes/navigator.dart';
import 'package:meow_hack_app/app/routes/routes.dart';

import 'package:meow_hack_app/app/uikit/widgets/nav_bar/custom_nav_bar.dart';
import 'package:meow_hack_app/app/uikit/theme/app_colors.dart';
import 'package:meow_hack_app/app/uikit/theme/app_theme.dart';

import 'package:meow_hack_app/app/settings/app_settings.dart';

import '../features/login/login_screen.dart';
import 'app_runner.dart';

import 'package:meow_hack_app/features/test/test.dart';

class App extends StatelessWidget {
  final DependenciesManager dependencies;
  final Env env;

  const App({
    super.key,
    required this.dependencies,
    required this.env,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OverlayManager()),
        ChangeNotifierProvider(create: (_) => AppSettings()), // Добавляем провайдер AppSettings
      ],
      child: DependenciesProvider(
        dependencies: dependencies,
        child: _App(env: env),
      ),
    );
  }
}

class _App extends StatelessWidget {
  final Env env;

  const _App({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    final LightThemeColors lightColors = LightThemeColors();
    final DarkThemeColors darkColors = DarkThemeColors();

    return Consumer<AppSettings>(
      builder: (context, appSettings, child) {
        return ScreenUtilInit(
          builder: (context, child) {
            final bool isTokenValid = appSettings.isAccessTokenValid();

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(lightColors),
              darkTheme: AppTheme.darkTheme(darkColors),
              themeMode: appSettings.themeMode,
              home: isTokenValid
                  ? _getInitialScreen()
                  : const LoginPage(), // Если токен невалиден, показываем LoginPage
            );
          },
        );
      },
    );
  }

  Widget _getInitialScreen() {
    switch (env) {
      case Env.dev:
        return ChangeNotifierProvider(
          create: (context) => TabManager(),
          child: const Scaffold(
            body: SafeArea(
              top: true,
              bottom: false,
              child: MainParentBuilder(),
            ),
          ),
        );
      case Env.prod:
        return ChangeNotifierProvider(
          create: (context) => TabManager(),
          child: const Scaffold(
            body: SafeArea(
              top: true,
              bottom: false,
              child: MainParentBuilder(),
            ),
          ),
        );
      case Env.test:
        return Test();
      default:
        return Placeholder();
    }
  }
}


class MainParentBuilder extends StatelessWidget {
  static PageRouter router = PageRouter();

  const MainParentBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TabManager>(
      builder: (context, tabManager, child) {
        return Scaffold(
          body: Stack(
            children: [
              FutureBuilder<List<Widget>>(
                future: router.pages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return IndexedStack(
                      index: tabManager.currentIndex,
                      children: snapshot.data!,
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Positioned(
                bottom: 25,
                child: Container(
                  height: 50,
                  child: CustomBottomNavigationBar(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
