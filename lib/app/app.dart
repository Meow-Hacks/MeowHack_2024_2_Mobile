import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:meow_hack_app/di/dependencies_provider.dart';
import 'package:meow_hack_app/di/dependencies_manager.dart';

import 'package:meow_hack_app/app/routes/navigator.dart';
import 'package:meow_hack_app/app/routes/routes.dart';

import 'package:meow_hack_app/app/uikit/widgets/nav_bar/custom_nav_bar.dart';

import '../di/overlay_manager.dart';
import 'app_runner.dart';

import 'package:meow_hack_app/features/test/test.dart';


class App extends StatelessWidget {
  final DependenciesManager dependencies;
  final Env env;

  const App({
    super.key,
    required this.dependencies,
    required this.env,  // Передаем параметр env в App
  });

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (_) => OverlayManager(),
      child: DependenciesProvider(
        dependencies: dependencies,
        child: _App(env: env),
      ),
    );
  }
}

class _App extends StatelessWidget {
  final Env env;  // Принимаем параметр env
  const _App({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: _getInitialScreen(),
        ),
      ),
    );
  }

  Widget _getInitialScreen() {
    switch (env) {
      case Env.dev:
        return Placeholder();
      case Env.prod:
        return ChangeNotifierProvider(
          create: (context) => TabManager(),
          child: const Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              top: true,
              bottom: false,
              child: MainParentBuilder(),
            )
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
                    // Показываем индикатор загрузки, пока данные загружаются
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Positioned(
                bottom: 0,
                child: CustomBottomNavigationBar()
              ),
            ],
          ),
          // bottomNavigationBar: ,
        );
      },
    );
  }
}
