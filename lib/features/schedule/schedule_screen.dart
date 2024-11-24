import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meow_hack_app/features/schedule/shedule_api.dart';
import 'package:meow_hack_app/features/test/globals.dart';
import 'package:provider/provider.dart';
import '../../../app/uikit/widgets/activity_calendar/activity_calendar_widget.dart';
import '../../../app/uikit/widgets/lesson_padding/lesson_widget.dart';
import '../../../models/lesson_model.dart';
import '../../di/global_data_provider.dart';

class LessonSchedulePage extends StatefulWidget {
  const LessonSchedulePage({Key? key}) : super(key: key);

  @override
  State<LessonSchedulePage> createState() => _LessonSchedulePageState();
}

class _LessonSchedulePageState extends State<LessonSchedulePage> {
  DateTime? selectedDate;
  List<LessonModel> allLessons = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final globalData = Provider.of<GlobalDataProvider>(context);
    isLoading = globalData.isLoading;
    allLessons = globalData.lessons;
    final filteredLessons = allLessons.where((lesson) {
      if (selectedDate == null) return true; // Если дата не выбрана, отображаем все
      return isSameDate(lesson.startTime, selectedDate!);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Календарь
          Padding(
            padding: const EdgeInsets.all(10),
            child: ActivityCalendar(
              onDaySelected: (date) {
                if (mounted) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          // Список занятий или ошибки/загрузка
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Показ загрузки
                : errorMessage != null
                ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
                : filteredLessons.isEmpty
                ? const Center(
                  child: Text(
                    'На сегодня расписание отсутствует',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                : ListView.builder(
              itemCount: filteredLessons.length,
              itemBuilder: (context, index) {
                final lesson = filteredLessons[index];
                return LessonWidget(lesson: lesson);
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
