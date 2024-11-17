import 'package:flutter/material.dart';
import 'package:meow_hack_app/di/dependencies_manager.dart';

class DependenciesProvider extends InheritedWidget {
  final DependenciesManager dependencies;
  const DependenciesProvider({
    super.key,
    required super.child,
    required this.dependencies,
  });
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static DependenciesManager of(BuildContext context) {
    final provider =
    context.getInheritedWidgetOfExactType<DependenciesProvider>();
    assert(provider != null, 'Dependencies not found');
    return provider!.dependencies;
  }
}
