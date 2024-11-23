import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/uikit/widgets/activity_calendar/activity_calendar_widget.dart';
import '../../../../app/uikit/widgets/lesson_padding/lesson_widget.dart';
import '../../../../models/lesson_model.dart';
import 'package:meow_hack_app/features/test/globals.dart';

class LessonSchedulePage extends StatefulWidget {
  const LessonSchedulePage({Key? key}) : super(key: key);

  @override
  State<LessonSchedulePage> createState() => _LessonSchedulePageState();
}

class _LessonSchedulePageState extends State<LessonSchedulePage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    // Фильтруем занятия по выбранной дате
    final filteredLessons = lessons.where((lesson) {
      if (selectedDate == null) return true; // Если дата не выбрана, отображаем все
      return isSameDate(lesson.startTime, selectedDate!);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Schedule'),
      ),
      body: Column(
        children: [
          // Календарь
          Padding(
            padding: const EdgeInsets.all(10),
            child: ActivityCalendar(
              onDaySelected: (date) {
                // Изменяем выбранную дату
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          // Список занятий
          Expanded(
            child: filteredLessons.isEmpty
                ? const Center(
              child: Text(
                'No lessons for the selected date.',
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
