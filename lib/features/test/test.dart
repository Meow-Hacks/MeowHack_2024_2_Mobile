import 'package:flutter/material.dart';

import '../../app/uikit/widgets/activity_calendar/activity_calendar_widget.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ActivityCalendar(),
        ), // Использование виджета ActivityCalendar
      ),
    );
  }
}
