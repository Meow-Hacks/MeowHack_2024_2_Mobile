import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meow_hack_app/app/uikit/widgets/new_nav_bar/new_bottom_bar.dart';
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

import '../di/global_data_provider.dart';
import '../features/login/login_screen.dart';
import '../features/login/login_api.dart'; // Import the login API
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
        ChangeNotifierProvider(create: (_) => GlobalDataProvider()),
        ChangeNotifierProvider(create: (_) => PageManager()),
      ],
      child: DependenciesProvider(
        dependencies: dependencies,
        child: _App(env: env),
      ),
    );
  }
}

class _App extends StatefulWidget {
  final Env env;

  const _App({super.key, required this.env});

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _handleAutomaticLogin(); // Handle automatic login
  }

  Future<void> _handleAutomaticLogin() async {
    if (widget.env == Env.dev || widget.env == Env.test) {
      Map<String, dynamic> response;
      final loginApi = LoginApi(context);
      try {
        response = await loginApi.studentLogin(
          email: 'ivanov@example.com',
          password: 'password1', 
        );


        // Сохраняем токены в AppSettings
        final appSettings = Provider.of<AppSettings>(context, listen: false);
        final accessToken = response['access_token'] as String;
        final refreshToken = response['refresh_token'] as String;

        await appSettings.setTokens(
          accessToken,
          refreshToken,
          DateTime.now().add(const Duration(hours: 1)), // Примерное время жизни access_token
        );
      } catch (e) {
        print('Automatic login failed: $e');
      }
    }

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final LightThemeColors lightColors = LightThemeColors();
    final DarkThemeColors darkColors = DarkThemeColors();
    final globalData = Provider.of<GlobalDataProvider>(context, listen: false);

    // Загружаем данные при запуске приложения
    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalData.fetchInitialData(context);
    });

    return Consumer<AppSettings>(
      builder: (context, appSettings, child) {
        final bool isTokenValid = appSettings.isAccessTokenValid();

        if (isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return ScreenUtilInit(
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(lightColors),
              darkTheme: AppTheme.darkTheme(darkColors),
              themeMode: appSettings.themeMode,
              home: isTokenValid
                  ? _getInitialScreen()
                  : const LoginPage(),
            );
          },
        );
      },
    );
  }

  Widget _getInitialScreen() {
    switch (widget.env) {
      case Env.dev:
      case Env.prod:
        return MainParentBuilder(env: widget.env);
      case Env.test:
        return Test();
      default:
        return const Placeholder();
    }
  }
}

class MainParentBuilder extends StatelessWidget {
  final Env env;

  const MainParentBuilder({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    final String role = appSettings.role; // Получаем роль пользователя
    final PageRouter router = PageRouter(env, role);
    final currentPage = Provider.of<PageManager>(context).currentPage;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          router.pages[currentPage],
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: NewBottomBar(
              backgroundColor: theme.colorScheme.surface,
              height: 70,
              icons: const [
                Icons.home_outlined,
                Icons.search,
                Icons.favorite_border,
                Icons.person_2_outlined,
              ],
              onPageSelected: (pageIndex) {
                print('Switched to page $pageIndex');
              },
            ),
          )
        ]
      ),
    );
  }
}
