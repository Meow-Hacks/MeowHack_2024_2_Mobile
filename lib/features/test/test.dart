import 'package:flutter/material.dart';
import 'package:meow_hack_app/features/login/login_screen.dart';

import '../../app/uikit/widgets/activity_calendar/activity_calendar_widget.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
