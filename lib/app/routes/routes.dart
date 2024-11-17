import 'package:flutter/material.dart';
import 'package:meow_hack_app/features/test/test.dart';


class PageRouter {
  PageRouter();

  Future<List<Widget>> get pages async {
    return [
      Center(child: Test()),
      Center(child: Placeholder()),
      Center(child: Placeholder()),
      Center(child: Placeholder()),
    ];
  }

  Future<int> get length async => (await pages).length;
}