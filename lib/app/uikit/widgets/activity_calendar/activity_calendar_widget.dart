import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Для форматирования даты

class ActivityCalendar extends StatefulWidget {
  const ActivityCalendar({Key? key}) : super(key: key);

  @override
  _ActivityCalendarState createState() => _ActivityCalendarState();
}

enum DisplayMode { oneWeek, twoWeeks, fullMonth }

class _ActivityCalendarState extends State<ActivityCalendar> {
  final List<String> daysOfWeek = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  DisplayMode _displayMode = DisplayMode.oneWeek;
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Общие настройки отступов и количества столбцов
    const double crossAxisSpacing = 2.0;
    const int crossAxisCount = 7;

    // Вычисление ширины ячейки с учетом отступов
    double gridWidth = (MediaQuery.of(context).size.width - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;

    List<int> daysToShow = _getDaysToShow();

    // Рассчитываем высоту контейнера в зависимости от режима отображения
    double calendarHeight = _calculateCalendarHeight(daysToShow.length) + 50;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: calendarHeight, // Ограничение высоты календаря
        ),
        child: GestureDetector(
          onVerticalDragEnd: _handleVerticalSwipe, // Обработчик вертикальных свайпов
          onHorizontalDragEnd: _handleHorizontalSwipe, // Обработчик горизонтальных свайпов
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Текущий месяц
                Text(
                  DateFormat.yMMMM().format(_currentDate),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Дни недели через GridView с гибкой высотой элементов
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: gridWidth,
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 2, // Соотношение ширины к высоте (делает элемент более овальным)
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            daysOfWeek[index],
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Сетка с днями месяца/недели
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: crossAxisSpacing,
                  ),
                  itemCount: daysToShow.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: gridWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2), // Полупрозрачный серый цвет
                        borderRadius: BorderRadius.circular(10), // Скругление углов
                      ),
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 4), // Отступ для текста
                      child: Text(
                        '${daysToShow[index]}',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateCalendarHeight(int totalDays) {
    const double dayOfWeekHeight = 40.0; // Высота строки с днями недели
    const double cellHeight = 50.0; // Высота ячейки дня месяца
    const double spacing = 2.0; // Расстояние между строками
    int rows;

    switch (_displayMode) {
      case DisplayMode.oneWeek:
        rows = 1; // Одна неделя
        break;
      case DisplayMode.twoWeeks:
        rows = 2; // Две недели
        break;
      case DisplayMode.fullMonth:
      default:
      // Рассчитываем количество строк для полного месяца
        rows = (totalDays / 7).ceil();
    }

    // Общая высота: высота дней недели + высота строк с днями месяца + отступы
    return dayOfWeekHeight + (rows * (cellHeight + spacing)) + 16 + 10; // Padding из контейнера
  }

  void _handleVerticalSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    if (details.primaryVelocity! < 0) {
      // Свайп вверх - уменьшение режима
      setState(() {
        if (_displayMode == DisplayMode.fullMonth) {
          _displayMode = DisplayMode.twoWeeks;
        } else if (_displayMode == DisplayMode.twoWeeks) {
          _displayMode = DisplayMode.oneWeek;
        }
      });
    } else if (details.primaryVelocity! > 0) {
      // Свайп вниз - увеличение режима
      setState(() {
        if (_displayMode == DisplayMode.oneWeek) {
          _displayMode = DisplayMode.twoWeeks;
        } else if (_displayMode == DisplayMode.twoWeeks) {
          _displayMode = DisplayMode.fullMonth;
        }
      });
    }
  }

  void _handleHorizontalSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    setState(() {
      if (_displayMode == DisplayMode.fullMonth) {
        // Листаем месяцы
        if (details.primaryVelocity! < 0) {
          // Свайп влево
          _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
        } else if (details.primaryVelocity! > 0) {
          // Свайп вправо
          _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
        }
      } else if (_displayMode == DisplayMode.twoWeeks) {
        // Листаем по две недели
        DateTime firstSeptember = DateTime(_currentDate.year, 9, 1);
        int daysSinceFirstSeptember = _currentDate.difference(firstSeptember).inDays;

        // Определяем, какая неделя сейчас (нечетная или четная)
        int currentWeekIndex = (daysSinceFirstSeptember / 7).floor();
        if (details.primaryVelocity! < 0) {
          // Свайп влево - вперед на две недели
          currentWeekIndex += 2;
        } else if (details.primaryVelocity! > 0) {
          // Свайп вправо - назад на две недели
          currentWeekIndex -= 2;
        }

        // Рассчитываем новую дату начала недели
        DateTime newStartDate = firstSeptember.add(Duration(days: currentWeekIndex * 7));
        _currentDate = newStartDate;
      } else {
        // Листаем по одной неделе
        if (details.primaryVelocity! < 0) {
          // Свайп влево - следующая неделя
          _currentDate = _currentDate.add(Duration(days: 7));
        } else if (details.primaryVelocity! > 0) {
          // Свайп вправо - предыдущая неделя
          _currentDate = _currentDate.subtract(Duration(days: 7));
        }
      }
    });
  }

  List<int> _getDaysToShow() {
    DateTime now = _currentDate;

    switch (_displayMode) {
      case DisplayMode.oneWeek:
      // Показать текущую неделю (7 дней)
        return _getCurrentWeek(now);
      case DisplayMode.twoWeeks:
      // Показать текущую и следующую неделю, учитывая нечетность
        List<int> firstWeek = _getCurrentWeek(now);
        List<int> secondWeek = _getNextWeek(now);
        return [...firstWeek, ...secondWeek];
      case DisplayMode.fullMonth:
      default:
      // Показать весь текущий месяц с дополнением
        return _getFullMonthWithPadding(now);
    }
  }


  List<int> _getFullMonthWithPadding(DateTime date) {
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    int firstDayOfMonthWeekday = DateTime(date.year, date.month, 1).weekday;
    int lastDayOfMonthWeekday = DateTime(date.year, date.month, daysInMonth).weekday;

    List<int> days = List<int>.generate(daysInMonth, (i) => i + 1);

    // Добавляем дни предыдущего месяца, если необходимо
    if (firstDayOfMonthWeekday != 1) {
      int previousMonthDays = DateTime(date.year, date.month, 0).day; // Количество дней в предыдущем месяце
      List<int> prevMonthDays = List<int>.generate(firstDayOfMonthWeekday - 1,
              (i) => previousMonthDays - (firstDayOfMonthWeekday - 2 - i)); // Создаем список в правильном порядке
      days = [...prevMonthDays, ...days];
    }

    // Добавляем дни следующего месяца, если необходимо
    if (lastDayOfMonthWeekday != 7) {
      for (int i = 1; i <= 7 - lastDayOfMonthWeekday; i++) {
        days.add(i);
      }
    }

    return days;
  }

  List<int> _getCurrentWeek(DateTime date) {
    int weekday = date.weekday;
    DateTime startOfWeek = date.subtract(Duration(days: weekday - 1));
    return List<int>.generate(7, (i) => startOfWeek.day + i).map((day) => (day > 31) ? day - 31 : day).toList();
  }

  List<int> _getNextWeek(DateTime date) {
    DateTime startOfNextWeek = date.add(Duration(days: 7));
    return _getCurrentWeek(startOfNextWeek);
  }
}
